class_name Bullet
extends Node3D

@export var fire_direction: Vector3
@export var speed: float = 20.

@onready var aread_3d: Area3D = $Area3D

func _ready() -> void:
    aread_3d.body_entered.connect(on_body_entered)
    
func _process(delta: float) -> void:
    global_position += fire_direction * speed * delta

func on_body_entered(body: Node3D) -> void:
    if body is PlayerRigidBody:
        body.player_ball.get_shot(fire_direction)
        
    self.queue_free()
