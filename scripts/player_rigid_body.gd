class_name PlayerRigidBody
extends RigidBody3D

var player_ball: PlayerBall

func _ready() -> void:
    var parent := get_parent()
    if parent is PlayerBall:
        player_ball = parent
