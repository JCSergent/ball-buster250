extends Node
class_name pulseObj

@export var pulsable : Node
@export var pulse_coefficient : float = 1.25
@export var pulse_speed = 5.0

@onready var current_scale

func _ready() -> void:
    current_scale = pulsable.scale

func pulse_this():
    pulsable.scale = current_scale
    
    var pulsed_scale = current_scale * pulse_coefficient
    
    pulsable.scale = move_toward(pulsed_scale, current_scale, pulse_speed)
