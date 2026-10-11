class_name PlayerBall
extends Node3D

@export var player_id: int = 1

@export var rolling_force := 10
@export var jump_impulse := 6

@export_group("Item Variables")
@export var speed_boost_power: float = 10.

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
@onready var floor_cast: RayCast3D = %FloorCast

var current_collectable: Collectable

var speed_boost_duration: float = 0.0

func _physics_process(delta: float) -> void:

    if Input.is_action_pressed("item_p1") and current_collectable != null:
        use_collectable()

    var is_on_floor := floor_cast.is_colliding()
    if not is_on_floor:
        return

    var rolling_velocity := rolling_force * delta
    if speed_boost_duration > 0.:
        rolling_velocity += speed_boost_power * delta
        speed_boost_duration -= delta

    if Input.is_action_pressed("forward_p1"):
        rigid_body_3d.angular_velocity.x -= rolling_velocity
    if Input.is_action_pressed("back_p1"):
        rigid_body_3d.angular_velocity.x += rolling_velocity
    if Input.is_action_pressed("left_p1"):
        rigid_body_3d.angular_velocity.z += rolling_velocity
    if Input.is_action_pressed("right_p1"):
        rigid_body_3d.angular_velocity.z -= rolling_velocity

    if Input.is_action_just_pressed("jump_p1"):
        rigid_body_3d.apply_central_impulse(Vector3.UP * jump_impulse)

func get_collectable(collectable: Collectable) -> void:
    current_collectable = collectable
    GameKeeper.add_item(player_id, current_collectable)

func use_collectable() -> void:
    GameKeeper.remove_item(player_id)

    if current_collectable.type == Collectable.Type.SpeedBoost:
        speed_boost_duration = current_collectable.use_duration

    current_collectable = null
