extends Node3D
class_name collectable

@onready var pickup_sound : AudioStreamPlayer = $pickupSound
@export var pickup_value : int = 1

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body:Node3D) -> void:
	if body is PlayerBall:
		EventBus.emit_signal("add_score", pickup_value)
		pickup_sound.play()
		self.queue_free()
