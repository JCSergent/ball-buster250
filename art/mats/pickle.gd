extends Sprite3D

@export var pickle_sound : SoundEffect

func _on_area_3d_body_entered(body: Node3D) -> void:
    AudioKeeper.play_sfx(pickle_sound)
    $pulseObj.pulse_this()
