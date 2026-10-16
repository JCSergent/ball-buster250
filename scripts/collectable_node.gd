class_name CollectableNode
extends Node3D

@export var collectable: Collectable

@onready var rigid_body_3d: RigidBody3D = $RigidBody3D
@onready var sprite: Sprite3D = $RigidBody3D/Sprite3D
@onready var floor_cast: RayCast3D = $RigidBody3D/FloorCast
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_flung: bool = false
var init_fling: bool = false
var flung_impulse: Vector3

func init(_collectable: Collectable) -> void:
    collectable = _collectable

func _ready() -> void:
    sprite.texture = collectable.texture
    animation_player.play('idle')

func _physics_process(delta: float) -> void:
    if is_flung:
        # if rigid_body_3d.linear_velocity == Vector3.ZERO:
        if init_fling:
            rigid_body_3d.apply_central_impulse(flung_impulse)
            init_fling = false
        elif floor_cast.is_colliding():
            rigid_body_3d.linear_velocity = Vector3.ZERO
            is_flung = false

func fling(impulse: Vector3) -> void:
    init_fling = true
    is_flung = true
    flung_impulse = impulse

func _on_area_3d_body_entered(body : Node3D) -> void:
    if is_flung:
        return
    if body is PlayerRigidBody and body.player_ball:
        var is_collected: bool = body.player_ball.get_collectable(collectable)

        if not is_collected:
            return

        if collectable.pickup_sound_effect:
            AudioKeeper.play_sfx(collectable.pickup_sound_effect)

        self.queue_free()
