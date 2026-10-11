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
    if body is PlayerRigidBody and body.player_ball:
        var is_collected: bool = body.player_ball.get_collectable(collectable)

        if not is_collected:
            return

        if collectable.pickup_sound_effect:
            AudioKeeper.play_sfx(collectable.pickup_sound_effect)

        self.queue_free()
