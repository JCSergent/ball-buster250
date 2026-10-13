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

func init(_collectable: Collectable) -> void:
	collectable = _collectable

func _ready() -> void:
	sprite.texture = collectable.texture
	animation_player.play('idle')

func _on_area_3d_body_entered(body:Node3D) -> void:
	if body is PlayerBall:
		
		
		if is_respawnable:
			despawn_me()
			respawn_me()
		else:
			atomize_me()

func despawn_me():
	sprite.visible = false
	area.set_collision_layer_value(1, false)
	area.set_collision_layer_value(2, false)
	area.set_collision_mask_value(1, false)
	area.set_collision_mask_value(2, false)

func respawn_me():
	timer.stop()
	timer.wait_time = respawn_time
	timer.one_shot = true
	timer.start()
	
	await timer.timeout
	sprite.visible = true
	area.set_collision_layer_value(1, true)
	area.set_collision_layer_value(2, true)
	area.set_collision_mask_value(1, true)
	area.set_collision_mask_value(2, true)

func atomize_me():
	self.queue_free()
