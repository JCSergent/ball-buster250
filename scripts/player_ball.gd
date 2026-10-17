class_name PlayerBall
extends Node3D

const BULLET_SCENE = preload("res://scenes/bullet.tscn")
const STAR_SCENE = preload("res://pickups/collectable.tscn")

@export var player_id: int = 1

@export var rolling_force := 40
@export var change_dir_dampening := 8
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

@onready var sun_beam_checker: Area3D = %SunBeamChecker

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
var is_fell_off_map: bool = false

var is_in_sunbeam: bool = false
var sunbeam_tween: Tween

func _ready() -> void:
    player = GameKeeper.players.get(player_id)
    sprite_3d.texture = player.sprite
    var ball_color: Color = player.color
    ball_color.a = 0.5
    ball.mesh.surface_get_material(1).albedo_color = ball_color
    outline.mesh.surface_get_material(1).set_shader_parameter("outline_color", ball_color)
    ui_color.color = player.color

    rigid_body_3d.body_entered.connect(on_body_entered)
    sun_beam_checker.area_entered.connect(on_enter_sun_beam)
    sun_beam_checker.area_exited.connect(on_exit_sun_beam)

func _physics_process(delta: float) -> void:
    var is_on_floor := floor_cast.is_colliding()

    # print(sun_beam_checker.has_overlapping_areas())

    # After falling off the map, lose half your stars
    if is_fell_off_map and is_on_floor:
        is_fell_off_map = false
        spew_stars(int((float(current_stars)/2)), 6, 10)

    # Shoot Gun
    if Input.is_action_just_pressed("jump_" + player.string_id):
        shoot_gun()

    # DRIFT & BOOST
    if Input.is_action_just_pressed("item_" + player.string_id):
        is_drifting = true

    elif is_drifting and Input.is_action_pressed("item_" + player.string_id):
        if not is_on_floor:
            rigid_body_3d.linear_damp = 0.
        else:
            rigid_body_3d.linear_damp = drift_dampening
            rigid_body_3d.linear_velocity.y = 0.
            if rigid_body_3d.linear_velocity.length() < drift_clamp:
                is_drifting = false
                is_boosting = true
                boost_duration = 0.
                rigid_body_3d.linear_damp = 0.
                rigid_body_3d.linear_velocity = Vector3.ZERO
                rigid_body_3d.angular_velocity = Vector3.ONE * 100
                rigid_body_3d.freeze = true
                drift_particles.lifetime = 2.
                drift_particles.speed_scale = 5.
                drift_particles.emitting = true

    elif is_boosting and Input.is_action_pressed("item_" + player.string_id):
        rigid_body_3d.angular_velocity = get_gun_direction() * 100
        if boost_duration < max_boost_duration:
            drift_particles.speed_scale += 2. * delta
            drift_particles.lifetime += 2. * delta
            boost_duration += delta
        else:
            boost_duration = max_boost_duration

    if Input.is_action_just_released("item_" + player.string_id):
        if is_drifting:
            rigid_body_3d.linear_damp = 0.
            rigid_body_3d.linear_velocity.y = 0.
        elif is_boosting:
            drift_particles.emitting = false
            rigid_body_3d.freeze = false
            rigid_body_3d.angular_velocity = Vector3.ZERO
            var boost_force: float = min_boost_force + (boost_duration / max_boost_duration) * (max_boost_force - min_boost_force)
            rigid_body_3d.apply_central_impulse(get_gun_direction() * boost_force)

        is_drifting = false
        is_boosting = false

    var adjusted_rolling_force: float = ((float() / max_star_capacity) * (min_rolling_force - rolling_force)) + rolling_force
    var rolling_velocity := adjusted_rolling_force * delta

    # Not used anymore, can remove later
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

    var linear_direction: Vector3 = rigid_body_3d.linear_velocity.normalized()
    if roll_direction != Vector2.ZERO and not is_drifting and is_on_floor:
        var deg_offset: float = abs(rad_to_deg(roll_direction.angle_to(Vector2(-linear_direction.x, linear_direction.z))))
        rigid_body_3d.linear_damp = change_dir_dampening * (deg_offset / 180)
    elif not is_drifting:
        rigid_body_3d.linear_damp = 0
        

func rotate_gun(target_rad: float, delta: float) -> void:
    # if not is_in_sunbeam:
    var angle_diff := wrapf(target_rad - gun_rotate_point.rotation.y, -PI, PI)
    if abs(angle_diff) > 0.1:
        gun_rotate_point.rotation.y += delta * TAU * gun_rotate_speed * sign(angle_diff)
    else:
        gun_rotate_point.rotation.y = target_rad

func shoot_gun() -> void:
    if current_collectable:
        use_collectable()
    elif  current_stars > 0:
        var bullet: Bullet = BULLET_SCENE.instantiate()
        bullet.fire_direction = get_gun_direction()
        get_parent().add_child(bullet)
        bullet.global_position = gun_fire_point.global_position

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

func get_gun_direction() -> Vector3:
    return gun_rotate_point.global_position.direction_to(gun_fire_point.global_position)

func fall_off_map() -> void:
    rigid_body_3d.freeze = false
    is_boosting = false
    is_drifting = false
    rigid_body_3d.global_position = Vector3(0, 6, 0)
    rigid_body_3d.angular_velocity = Vector3.ZERO
    rigid_body_3d.linear_velocity = Vector3.DOWN * 10
    rigid_body_3d.apply_central_impulse(Vector3.DOWN * 50.)
    is_fell_off_map = true

func spew_stars(amount: int, min_force: float, max_force: float, spew_direction: Vector3 = Vector3.ZERO) -> void:
    for i in amount:
        var direction := spew_direction
        if direction == Vector3.ZERO:
            direction = Vector3(0.4, 0.6, 0)
            direction = direction.rotated(Vector3.UP, randf_range(0, 2*PI))
        else:
            direction = direction.rotated(Vector3.UP, randf_range(-PI/6, PI/6))
            direction.y += 0.4
            direction = direction.normalized()
            
        var star: CollectableNode = STAR_SCENE.instantiate()
        star.position = rigid_body_3d.position
        star.fling(direction * randf_range(min_force, max_force))
        add_child(star)

    increase_stars(amount * -1)

func get_shot(direction: Vector3) -> void:
    rigid_body_3d.apply_central_impulse(direction * star_projectile_force)

    if current_stars > 0 and current_stars < 4:
        spew_stars(current_stars, 3, 6, direction)
    elif current_stars > 0:
        spew_stars(randi_range(2, 4), 3, 6, direction)
    
func on_body_entered(body: Node3D) -> void:
    if body is PlayerRigidBody:
        var direction: Vector3 = rigid_body_3d.global_position.direction_to(body.global_position) * -1
        rigid_body_3d.apply_central_impulse(direction * player_bump_force)
        if current_stars > 0 and current_stars < 4:
            spew_stars(current_stars, 3, 6, direction)
        elif current_stars > 0:
            spew_stars(randi_range(2, 4), 3, 6, direction)

func on_enter_sun_beam(_area: Area3D) -> void:
    print('enter sun beam')
    is_in_sunbeam = true
    if sunbeam_tween:
        sunbeam_tween.stop()
    sunbeam_tween = get_tree().create_tween()
    sunbeam_tween.tween_property(gun_rotate_point, "rotation_degrees:z", -90, 0.2)

func on_exit_sun_beam(_area: Area3D) -> void:
    print('exit sun beam')
    is_in_sunbeam = false
    if sunbeam_tween:
        sunbeam_tween.stop()
    sunbeam_tween = get_tree().create_tween()
    sunbeam_tween.tween_property(gun_rotate_point, "rotation:z", 0, 0.2)
