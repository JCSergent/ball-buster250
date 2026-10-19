extends Node
class_name pulseObj

@export var pulsable : Node
@export var pulse_coefficient : float = 1.25
@export var pulse_dur = 0.2

@onready var base_scale

var tween : Tween

func _ready() -> void:
    base_scale = pulsable.scale

func pulse_this():
    if tween and tween.is_running():
        tween.kill()
    
    pulsable.scale = base_scale * pulse_coefficient
    
    tween = create_tween()
    tween.tween_property(pulsable, "scale", base_scale, pulse_dur).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
