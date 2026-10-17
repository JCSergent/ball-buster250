extends PanelContainer


func _on_start_butt_pressed() -> void:
    get_tree().change_scene_to_file("res://menus/char_select_menu.tscn")


func _on_quit_butt_pressed() -> void:
    get_tree().quit()
