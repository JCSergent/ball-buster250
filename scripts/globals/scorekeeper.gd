extends Node

@onready var p1_score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect("add_score" , add_score)
	
	#zero all score:
	p1_score = 0
	#update hud
	add_score(0)

func add_score(value : int):
	p1_score += value
	EventBus.emit_signal("update_score_hud", p1_score)
