class_name CollectableNode
extends Node3D

@export var collectable: Collectable

@onready var sprite: Sprite3D = $Sprite3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func init(_collectable: Collectable) -> void:
    collectable = _collectable

func _ready() -> void:
    sprite.texture = collectable.texture
    animation_player.play('idle')

func _on_area_3d_body_entered(body : Node3D) -> void:
    if body is PlayerRigidBody:
        var player_id: int = body.player_ball.player_id
        if collectable.type == Collectable.Type.Point1:
            GameKeeper.add_score(player_id, 1)
        elif collectable.type == Collectable.Type.Point5:
            GameKeeper.add_score(player_id, 5)
        elif collectable.type == Collectable.Type.Point10:
            GameKeeper.add_score(player_id, 10)
        else:
            body.player_ball.get_collectable(collectable)

        if collectable.pickup_sound_effect:
            AudioKeeper.play_sfx(collectable.pickup_sound_effect)
        self.queue_free()
