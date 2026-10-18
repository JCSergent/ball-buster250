extends Area3D


func _ready() -> void:
    body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D) -> void:
    if body is PlayerRigidBody and body.player_ball:
        body.player_ball.fall_off_map()
    elif body is CollectableRigidBody and body.collectable:
        body.collectable.queue_free()
