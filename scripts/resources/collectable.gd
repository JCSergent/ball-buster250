class_name Collectable
extends Resource

@export var type: Type
@export var texture: Texture2D
@export var pickup_sound_effect: SoundEffect
@export var use_sound_effect: SoundEffect
@export var use_duration: float

enum Type {
    Point1,
    Point5,
    Point10,
    SpeedBoost,
    Spring,

    Mushroom,
    Rocket,
    GrappleHook
    # Below are not implemented
    # GrappleHook,
    # Bomb,
    # FreezeRay,
    # StarFall,
    # TBD - come up with more collectables
}
