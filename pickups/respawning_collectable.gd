class_name respawning_collectable extends Node3D

@export var collectable: Collectable

#not used but maybe?
@export var is_respawnable : bool = true

@onready var timer := $Timer
@export var respawn_time := 15.0
@export var value : int =  1

@onready var sprite: Sprite3D = $Sprite3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area : Area3D = $Area3D

var current_collectable: CollectableNode

func init(_collectable: Collectable) -> void:
    collectable = _collectable

func _ready() -> void:
    pass
    # sprite.texture = collectable.texture
    # animation_player.play('idle')

func _process(_delta: float) -> void:
    if not current_collectable:
        spawn_new_collectable()

func spawn_new_collectable() -> void:
    var new_collectable: CollectableNode = CollectableNode.new() 
    # print(collectable)
    # print(collectable.type)
    # new_collectable.init(collectable)
    new_collectable.collectable = collectable
    current_collectable = new_collectable
    add_child(new_collectable)
        
# func _on_area_3d_body_entered(body:Node3D) -> void:
#     if body is PlayerRigidBody and body.player_ball:
#         var is_collected: bool = body.player_ball.get_collectable(collectable)
#
#         if not is_collected:
#             return
#
#         if collectable.pickup_sound_effect:
#             AudioKeeper.play_sfx(collectable.pickup_sound_effect)
#
#         despawn_me()
#         respawn_me()

# func despawn_me():
#     sprite.visible = false
#     area.set_collision_layer_value(1, false)
#     area.set_collision_layer_value(2, false)
#     area.set_collision_mask_value(1, false)
#     area.set_collision_mask_value(2, false)
#
# func respawn_me():
#     timer.stop()
#     timer.wait_time = respawn_time
#     timer.one_shot = true
#     timer.start()
#
#     await timer.timeout
#     sprite.visible = true
#     area.set_collision_layer_value(1, true)
#     area.set_collision_layer_value(2, true)
#     area.set_collision_mask_value(1, true)
#     area.set_collision_mask_value(2, true)
#
# func atomize_me():
#     self.queue_free()
