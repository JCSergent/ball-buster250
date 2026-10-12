class_name PlayerBall
extends Node3D

const BULLET_SCENE = preload("res://scenes/bullet.tscn")

@export var player_id: int = 1

@export var rolling_force := 16
@export var jump_impulse := 6
@export var gun_rotate_speed := 0.8

@export_group("Grow Stats")
@export var max_gem_capacity := 40
@export var max_scale_increase := 2.
@export var min_rolling_force := 8

@export_group("Item Variables")
@export var speed_boost_impulse: float = 12.
@export var speed_boost_power: float = 10.
@export var spring_impulse: float = 10.

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
@onready var floor_cast: RayCast3D = %FloorCast
@onready var gun_rotate_point: Node3D = %GunRotatePoint
@onready var gun_fire_point: Node3D = %GunFirePoint

@onready var sprite_3d: Sprite3D = %Sprite3D
@onready var ball: MeshInstance3D = %Ball

var player: Player

var current_collectable: Collectable
var current_gems: int = 0

var speed_boost_duration: float = 0.0

func _ready() -> void:
    player = GameKeeper.players.get(player_id)
    sprite_3d.texture = player.sprite
    var ball_color: Color = player.color
    ball_color.a = 0.5
    ball.mesh.surface_get_material(1).albedo_color = ball_color
    

func _physics_process(delta: float) -> void:
    if Input.is_action_pressed("item_" + player.string_id) and current_collectable != null:
        use_collectable()

    if Input.is_action_just_pressed("jump_" + player.string_id):
        shoot_gun()

    var is_on_floor := floor_cast.is_colliding()
    # if not is_on_floor:
    #     return

    var adjusted_rolling_force: float = ((float(current_gems) / max_gem_capacity) * (min_rolling_force - rolling_force)) + rolling_force
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
    if current_gems < 1:
        # TODO: maybe play a little animation showing there is nothing to shoot
        return

    var bullet: Bullet = BULLET_SCENE.instantiate()
    bullet.global_position = gun_fire_point.global_position
    bullet.fire_direction = get_gun_direction()
    get_parent().add_child(bullet)

    increase_gems(-1)

func get_collectable(collectable: Collectable) -> bool:
    if collectable.type == Collectable.Type.Point1:
        if current_gems >= max_gem_capacity:
            return false
        increase_gems(1)
    elif collectable.type == Collectable.Type.Point5:
        if current_gems >= max_gem_capacity:
            return false
        increase_gems(5)
    elif collectable.type == Collectable.Type.Point10:
        if current_gems >= max_gem_capacity:
            return false
        increase_gems(10)
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

func increase_gems(amount: int) -> void:
    current_gems = clampi(current_gems + amount, 0, max_gem_capacity)
    var new_scale: float = ((float(current_gems) / max_gem_capacity) * (max_scale_increase - 1.)) + 1.
    rigid_body_3d.scale = Vector3.ONE * new_scale
    GameKeeper.update_score(player_id, current_gems)

func get_gun_direction() -> Vector3:
    return gun_rotate_point.global_position.direction_to(gun_fire_point.global_position)

func fall_off_map() -> void:
    rigid_body_3d.global_position = Vector3(0, 6, 0)
    rigid_body_3d.angular_velocity = Vector3.ZERO
    rigid_body_3d.linear_velocity = Vector3.ZERO
    rigid_body_3d.apply_central_impulse(Vector3.DOWN * 30.)
    # cut gems in half
    increase_gems(-int((float(current_gems)/2)))
