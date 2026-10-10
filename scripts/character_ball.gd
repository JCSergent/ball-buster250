extends RigidBody3D
class_name PlayerBall

@export var rolling_force := 40
@export var jump_impulse := 6


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("forward_p1"):
		angular_velocity.x -= rolling_force * delta
	if Input.is_action_pressed("back_p1"):
		angular_velocity.x += rolling_force * delta
	if Input.is_action_pressed("left_p1"):
		angular_velocity.z += rolling_force * delta
	if Input.is_action_pressed("right_p1"):
		angular_velocity.z -= rolling_force * delta

	if Input.is_action_just_pressed("jump_p1"):
		apply_central_impulse(Vector3.UP * jump_impulse)
		
