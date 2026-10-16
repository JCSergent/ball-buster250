class_name Bullet
extends Node3D

@export var fire_direction: Vector3
@export var speed: float = 20.

@onready var aread_3d: Area3D = $Area3D
@onready var floor_cast: RayCast3D = $FloorCast
@onready var forward_cast: RayCast3D = $ForwardCast

func _ready() -> void:
    aread_3d.body_entered.connect(on_body_entered)
    forward_cast.target_position = fire_direction * 2
    
func _process(delta: float) -> void:
    if floor_cast.is_colliding():
        global_position.y = floor_cast.get_collision_point().y + 0.4
    global_position += fire_direction * speed * delta

func on_body_entered(body: Node3D) -> void:
    if body is PlayerRigidBody:
        body.player_ball.get_shot(fire_direction)
        self.queue_free()
    elif forward_cast.is_colliding() and forward_cast.get_collision_normal() != Vector3.DOWN:
        self.queue_free()
