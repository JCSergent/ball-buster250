class_name PlayerBall
extends Node3D

@export var rolling_force := 10
@export var jump_impulse := 6

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
@onready var floor_cast: RayCast3D = %FloorCast

var current_collectable: Collectable

func _physics_process(delta: float) -> void:

    var is_on_floor := floor_cast.is_colliding()
    if not is_on_floor:
        return

    if Input.is_action_pressed("forward_p1"):
        rigid_body_3d.angular_velocity.x -= rolling_force * delta
    if Input.is_action_pressed("back_p1"):
        rigid_body_3d.angular_velocity.x += rolling_force * delta
    if Input.is_action_pressed("left_p1"):
        rigid_body_3d.angular_velocity.z += rolling_force * delta
    if Input.is_action_pressed("right_p1"):
        rigid_body_3d.angular_velocity.z -= rolling_force * delta

    if Input.is_action_just_pressed("jump_p1"):
        rigid_body_3d.apply_central_impulse(Vector3.UP * jump_impulse)

func get_collectable(collectable: Collectable) -> void:
    current_collectable = collectable
