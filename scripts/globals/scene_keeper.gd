extends Control

signal done_loading

@export var loadable_scenes: Dictionary[Scene, PackedScene]
@export var min_load_time: float = 0.5

@onready var loading_screen: CanvasLayer = $LoadingScreen

enum Scene { PlayerSelectScene, GameScene, MainMenuScene, VictoryScene }

func load_scene(scene: Scene) -> void:
    if loadable_scenes.has(scene):
        loading_screen.visible = true
        var start_time := Time.get_unix_time_from_system()
        await get_tree().process_frame

        var packed_scene: PackedScene = loadable_scenes.get(scene)
        get_tree().change_scene_to_packed(packed_scene)
        await get_tree().scene_changed

        var duration := start_time - Time.get_unix_time_from_system()
        if duration < min_load_time:
            await get_tree().create_timer(min_load_time - duration).timeout

        loading_screen.visible = false
        done_loading.emit()
    else:
        push_error("Scene Manager failed to find scene ", scene)
