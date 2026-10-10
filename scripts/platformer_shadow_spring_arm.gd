extends SpringArm3D

@onready var ShadowDecal : Decal = $ShadowDecal
@onready var max_shadowspring_length = spring_length
@onready var parent = get_node("../../..")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	manage_shadow()
	#pass

func manage_shadow():
	var new_scale : float = get_hit_length() / max_shadowspring_length
	new_scale = 1.0 - new_scale
	new_scale = clamp(new_scale, 0.5, 1.0)
	ShadowDecal.size = Vector3(new_scale, 1.0, new_scale)
