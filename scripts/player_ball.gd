class_name PlayerBall
extends Node3D

const BULLET_SCENE = preload("res://scenes/bullet.tscn")

@export var player_id: int = 1

@export var rolling_force := 16
# @export var jump_impulse := 6
@export var gun_rotate_speed := 1.5

@export_group("Boost")
@export var min_boost_force := 4
@export var max_boost_force := 10
@export var max_boost_duration := 2
@export var drift_dampening := 8
@export var drift_clamp := 2

@export_group("Grow Stats")
@export var max_star_capacity := 60
@export var max_scale_increase := 2.
@export var min_rolling_force := 8

@export_group("Item Variables")
@export var speed_boost_impulse: float = 12.
@export var speed_boost_power: float = 10.
@export var spring_impulse: float = 10.

@export_group("Collisions")
@export var player_bump_force: float = 3.
@export var star_projectile_force: float = 2.

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
@onready var floor_cast: RayCast3D = %FloorCast
@onready var gun_rotate_point: Node3D = %GunRotatePoint
@onready var gun_fire_point: Node3D = %GunFirePoint

@onready var sprite_3d: Sprite3D = %Sprite3D
@onready var outline: MeshInstance3D = %Outline
@onready var ball: MeshInstance3D = %Ball
@onready var star_count: Label = %StarCount
@onready var ui_color: ColorRect = %UIColor

@onready var drift_particles: GPUParticles3D = %DriftParticles

var player: Player

var current_collectable: Collectable
var current_stars: int = 0

var speed_boost_duration: float = 0.0

var is_boosting: bool = false
var boost_duration: float = 0.
var is_drifting: bool = false

func _ready() -> void:
    player = GameKeeper.players.get(player_id)
    sprite_3d.texture = player.sprite
    var ball_color: Color = player.color
    ball_color.a = 0.5
    ball.mesh.surface_get_material(1).albedo_color = ball_color
    outline.mesh.surface_get_material(1).set_shader_parameter("outline_color", ball_color)
    ui_color.color = player.color

    rigid_body_3d.body_entered.connect(on_body_entered)

func _physics_process(delta: float) -> void:
    # if Input.is_action_pressed("item_" + player.string_id) and current_collectable != null:
    #     use_collectable()

    if Input.is_action_just_pressed("jump_" + player.string_id):
        shoot_gun()

    var is_on_floor := floor_cast.is_colliding()

    # DRIFT & BOOST
    if is_on_floor and Input.is_action_just_pressed("item_" + player.string_id):
        is_drifting = true
        rigid_body_3d.linear_damp = drift_dampening
        rigid_body_3d.linear_velocity.y = 1.

    elif is_drifting and Input.is_action_pressed("item_" + player.string_id):
        if is_on_floor and rigid_body_3d.linear_velocity.length() < drift_clamp:
            is_drifting = false
            is_boosting = true
            boost_duration = 0.
            rigid_body_3d.linear_velocity = Vector3.ZERO
            rigid_body_3d.angular_velocity = Vector3.ONE * 100
            rigid_body_3d.freeze = true
            drift_particles.lifetime = 2.
            drift_particles.speed_scale = 5.
            drift_particles.emitting = true

    elif is_boosting and Input.is_action_pressed("item_" + player.string_id):
        rigid_body_3d.angular_velocity = get_gun_direction() * 100
        # rigid_body_3d.linear_velocity = Vector3.ZERO
        if boost_duration < max_boost_duration:
            drift_particles.speed_scale += 2. * delta
            drift_particles.lifetime += 2. * delta
            boost_duration += delta
        else:
            boost_duration = max_boost_duration

    if Input.is_action_just_released("item_" + player.string_id):
        if is_boosting:
            drift_particles.emitting = false
            rigid_body_3d.freeze = false
            rigid_body_3d.linear_damp = 0.
            rigid_body_3d.angular_velocity = Vector3.ZERO
            var boost_force: float = min_boost_force + (boost_duration / max_boost_duration) * (max_boost_force - min_boost_force)
            rigid_body_3d.apply_central_impulse(get_gun_direction() * boost_force)

        is_drifting = false
        is_boosting = false

    var adjusted_rolling_force: float = ((float() / max_star_capacity) * (min_rolling_force - rolling_force)) + rolling_force
    var rolling_velocity := adjusted_rolling_force * delta

    if speed_boost_duration > 0.:
        rolling_velocity += speed_boost_power * delta
        speed_boost_duration -= delta

    var roll_direction = Input.get_vector("right_" + player.string_id, "left_" + player.string_id, "forward_" + player.string_id, "back_" + player.string_id)

    if is_on_floor:
        rigid_body_3d.angular_velocity.x += roll_direction.y * rolling_velocity
        rigid_body_3d.angular_velocity.z += roll_direction.x * rolling_velocity
    else:
        var offset: float = 0.15
        rigid_body_3d.linear_velocity.x -= roll_direction.x * rolling_velocity * offset
        rigid_body_3d.linear_velocity.z += roll_direction.y * rolling_velocity * offset

    if roll_direction != Vector2.ZERO:
        rotate_gun(roll_direction.angle(), delta)

    # if Input.is_action_just_pressed("jump_p1"):
        # rigid_body_3d.apply_central_impulse(Vector3.UP * jump_impulse)

func rotate_gun(target_rad: float, delta: float) -> void:
    if gun_rotate_point.rotation.y != target_rad:
        var angle_diff := wrapf(target_rad - gun_rotate_point.rotation.y, -PI, PI)
        gun_rotate_point.rotation.y += delta * TAU * gun_rotate_speed * sign(angle_diff)
        if abs(gun_rotate_point.rotation.y - target_rad) <= 0.1:
            gun_rotate_point.rotation.y = target_rad

func shoot_gun() -> void:
    if current_collectable:
        print("use collectable")
        use_collectable()
    elif  current_stars > 0:
        var bullet: Bullet = BULLET_SCENE.instantiate()
        get_parent().add_child(bullet)
        bullet.global_position = gun_fire_point.global_position
        bullet.fire_direction = get_gun_direction()

        increase_stars(-1)
    else:
        # TODO: maybe play a little animation showing there is nothing to shoot
        pass

func get_collectable(collectable: Collectable) -> bool:
    if collectable.type == Collectable.Type.Point1:
        if  current_stars >= max_star_capacity:
            return false
        increase_stars(1)
    elif collectable.type == Collectable.Type.Point5:
        if  current_stars >= max_star_capacity:
            return false
        increase_stars(5)
    elif collectable.type == Collectable.Type.Point10:
        if  current_stars >= max_star_capacity:
            return false
        increase_stars(10)
    else:
        if current_collectable:
            return false
        current_collectable = collectable
        GameKeeper.add_item(player_id, current_collectable)

    return true

func use_collectable() -> void:
    GameKeeper.remove_item(player_id)

    if current_collectable.type == Collectable.Type.SpeedBoost:
        rigid_body_3d.apply_central_impulse(-1 * get_gun_direction() * speed_boost_impulse)
        # speed_boost_duration = current_collectable.use_duration
    elif current_collectable.type == Collectable.Type.Spring:
        rigid_body_3d.apply_central_impulse(Vector3.UP * spring_impulse)

    current_collectable = null

func increase_stars(amount: int) -> void:
    current_stars = clampi(current_stars + amount, 0, max_star_capacity)
    var new_scale: float = ((float() / max_star_capacity) * (max_scale_increase - 1.)) + 1.
    rigid_body_3d.scale = Vector3.ONE * new_scale
    star_count.text = str(current_stars)
    # GameKeeper.update_score(player_id, )

func get_gun_direction() -> Vector3:
    return gun_rotate_point.global_position.direction_to(gun_fire_point.global_position)

func fall_off_map() -> void:
    rigid_body_3d.global_position = Vector3(0, 6, 0)
    rigid_body_3d.angular_velocity = Vector3.ZERO
    rigid_body_3d.linear_velocity = Vector3.ZERO
    rigid_body_3d.apply_central_impulse(Vector3.DOWN * 30.)
    # cut stars in half
    increase_stars(-int((float()/2)))

func on_body_entered(body: Node3D) -> void:
    # print('body entered')
    # print(body)
    if body is PlayerRigidBody:
        var direction: Vector3 = rigid_body_3d.global_position.direction_to(body.global_position) * -1
        rigid_body_3d.apply_central_impulse(direction * player_bump_force)
        
