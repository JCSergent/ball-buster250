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
        if collectable.type == Collectable.Type.Point1:
            EventBus.add_score.emit(1)
        elif collectable.type == Collectable.Type.Point5:
            EventBus.add_score.emit(5)
        elif collectable.type == Collectable.Type.Point10:
            EventBus.add_score.emit(10)
        else:
            body.player_ball.get_collectable(collectable)

        if collectable.sound_effect:
            AudioManager.play_sfx(collectable.sound_effect)

        self.queue_free()
