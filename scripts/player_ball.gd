class_name PlayerBall
extends Node3D

const BULLET_SCENE = preload("res://scenes/bullet.tscn")

@export var player_id: int = 1

@export var rolling_force := 16
@export var jump_impulse := 6
@export var gun_rotate_speed := 0.4

@export_group("Grow Stats")
@export var max_gem_capacity := 40
@export var max_scale_increase := 2.
@export var min_rolling_force := 8

@export_group("Item Variables")
@export var speed_boost_power: float = 10.

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
@onready var floor_cast: RayCast3D = %FloorCast
@onready var gun_rotate_point: Node3D = %GunRotatePoint
@onready var gun_fire_point: Node3D = %GunFirePoint

var current_collectable: Collectable
var current_gems: int = 0

var speed_boost_duration: float = 0.0

func _physics_process(delta: float) -> void:
    if Input.is_action_pressed("item_p1") and current_collectable != null:
        use_collectable()

    if Input.is_action_just_pressed("jump_p1"):
        shoot_gun()

    var is_on_floor := floor_cast.is_colliding()
    if not is_on_floor:
        return

    var adjusted_rolling_force: float = ((float(current_gems) / max_gem_capacity) * (min_rolling_force - rolling_force)) + rolling_force
    var rolling_velocity := adjusted_rolling_force * delta

    if speed_boost_duration > 0.:
        rolling_velocity += speed_boost_power * delta
        speed_boost_duration -= delta

    if Input.is_action_pressed("forward_p1"):
        rigid_body_3d.angular_velocity.x -= rolling_velocity
        rotate_gun(-90, delta)
    if Input.is_action_pressed("back_p1"):
        rigid_body_3d.angular_velocity.x += rolling_velocity
        rotate_gun(90, delta)
    if Input.is_action_pressed("left_p1"):
        rigid_body_3d.angular_velocity.z += rolling_velocity
        rotate_gun(0, delta)
    if Input.is_action_pressed("right_p1"):
        rigid_body_3d.angular_velocity.z -= rolling_velocity
        rotate_gun(180, delta)

    # if Input.is_action_just_pressed("jump_p1"):
        # rigid_body_3d.apply_central_impulse(Vector3.UP * jump_impulse)

func rotate_gun(target_deg: int, delta: float) -> void:
    var target_rad := deg_to_rad(target_deg)
    if gun_rotate_point.rotation.y != target_rad:
        var angle_diff := wrapf(target_rad - gun_rotate_point.rotation.y, -PI, PI)
        gun_rotate_point.rotation.y += delta * TAU * gun_rotate_speed * sign(angle_diff)
        if abs(gun_rotate_point.rotation.y - target_rad) <= 0.05:
            gun_rotate_point.rotation.y = target_rad

func shoot_gun() -> void:
    if current_gems < 1:
        # TODO: maybe play a little animation showing there is nothing to shoot
        return

    var bullet: Bullet = BULLET_SCENE.instantiate()
    bullet.global_position = gun_fire_point.global_position
    bullet.fire_direction = gun_rotate_point.global_position.direction_to(gun_fire_point.global_position)
    get_parent().add_child(bullet)

    increase_gems(-1)

func get_collectable(collectable: Collectable) -> void:
    if collectable.type == Collectable.Type.Point1:
        increase_gems(1)
    elif collectable.type == Collectable.Type.Point5:
        increase_gems(5)
    elif collectable.type == Collectable.Type.Point10:
        increase_gems(10)
    else:
        current_collectable = collectable
        GameKeeper.add_item(player_id, current_collectable)

func use_collectable() -> void:
    GameKeeper.remove_item(player_id)

    if current_collectable.type == Collectable.Type.SpeedBoost:
        speed_boost_duration = current_collectable.use_duration

    current_collectable = null

func increase_gems(amount: int) -> void:
    current_gems = clampi(current_gems + amount, 0, max_gem_capacity)
    var new_scale: float = ((float(current_gems) / max_gem_capacity) * (max_scale_increase - 1.)) + 1.
    rigid_body_3d.scale = Vector3.ONE * new_scale
    GameKeeper.update_score(player_id, current_gems)
