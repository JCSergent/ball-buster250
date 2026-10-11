class_name SoundEffect 
extends Resource

# Sound effect resource, used to configure unique sound effects for use with the AudioManager.
# Passed to [method AudioManager.create_2d_audio_at_location()] and [method AudioManager.create_audio()] to play sound effects.

@export var audio_stream: AudioStream ## The [WAV/OGG] audio resource to play.
@export_range(-40, 20) var volume: float = 0
@export_range(0.0, 4.0,.01) var pitch_scale: float = 1.0
@export_range(0.0, 1.0,.01) var pitch_randomness: float = 0.0

@export_range(0, 10) var duplicate_limit: int = 5 ## Maximum number of this SoundEffect to play simultaneously before culled.
@export_range(0.0, 2.0, 0.01) var duplicate_cooldown: float = 0.0 ## Cooldown Period before the same sound effect can be played

var audio_count: int = 0 ## The instances of sound effect currently playing.

var _last_play_time: float = -999.0

func can_play() -> bool:
    if duplicate_cooldown <= 0.0:
        return audio_count < duplicate_limit
    else:
        var now = Time.get_ticks_msec() / 1000.0
        return (audio_count < duplicate_limit) and (now - _last_play_time) >= duplicate_cooldown

func mark_played() -> void:
    _last_play_time = Time.get_ticks_msec() / 1000.0
    change_audio_count(1)

func change_audio_count(amount: int) -> void:
    audio_count = max(0, audio_count + amount)

func on_audio_finished() -> void:
    change_audio_count(-1)

