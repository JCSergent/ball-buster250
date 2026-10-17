extends PanelContainer


func _on_start_butt_pressed() -> void:
    SceneKeeper.load_scene(SceneKeeper.Scene.PlayerSelectScene)

func _on_quit_butt_pressed() -> void:
    get_tree().quit()
