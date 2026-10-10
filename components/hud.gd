extends CanvasLayer
class_name hud

@onready var p1_score := $P1/Score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect("update_score_hud" , on_score_updated)
	
	#this seems weird:
	p1_score.text = str(Scorekeeper.p1_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_score_updated(value : int):
	p1_score.text = str(value)
