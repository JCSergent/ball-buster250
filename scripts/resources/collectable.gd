class_name Collectable
extends Resource

@export var type: Type
@export var texture: Texture2D
@export var sound_effect: SoundEffect

enum Type {
    Point1,
    Point5,
    Point10,
    SpeedBoost,
    GrappleHook,
    StarFall,
    # TBD - come up with more collectables
}
