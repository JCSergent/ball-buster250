extends Node3D
class_name main_menu_3d

func _on_start_butt_pressed() -> void:
    get_tree().change_scene_to_file("res://menus/char_select_menu.tscn")
