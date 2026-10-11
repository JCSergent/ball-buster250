extends Node

func play_sfx(sound_effect: SoundEffect) -> void:
    if sound_effect.can_play():
        sound_effect.mark_played()

        var new_sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()
        add_child(new_sfx_player)
        new_sfx_player.bus = &'SFX'
        new_sfx_player.stream = sound_effect.audio_stream
        new_sfx_player.volume_db = sound_effect.volume
        new_sfx_player.pitch_scale = sound_effect.pitch_scale

        if sound_effect.pitch_randomness != 0.0:
            new_sfx_player.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness)

        new_sfx_player.finished.connect(sound_effect.on_audio_finished)
        new_sfx_player.finished.connect(new_sfx_player.queue_free)
        new_sfx_player.play()

        # var sound_effect: SoundEffect = sound_effect_dict[type]
        # if sound_effect.can_play():
        #     sound_effect.mark_played()
        #     sound_effect.change_audio_count(1)
        #     var new_2D_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
        #     add_child(new_2D_audio)
        #     new_2D_audio.bus = &'SFX'
        #     new_2D_audio.position = location
        #     new_2D_audio.stream = sound_effect.sound_effect
        #     new_2D_audio.volume_db = sound_effect.volume
        #     new_2D_audio.pitch_scale = sound_effect.pitch_scale
        #     # new_2D_audio.pitch_scale += Global.rng.randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness )
        #     new_2D_audio.finished.connect(sound_effect.on_audio_finished)
        #     new_2D_audio.finished.connect(new_2D_audio.queue_free)
        #     new_2D_audio.play()

