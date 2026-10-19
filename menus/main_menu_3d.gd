extends Node3D
class_name main_menu_3d
    
@onready var anim : AnimationPlayer = $JoyceMenu/Island/AnimationPlayer
    
func _ready() -> void:
    anim.play("float")

func _process(delta):
    is_anything_pressed()


func is_anything_pressed():
  var InputMapList:Array = InputMap.get_actions()
  for actions in InputMapList:
    if Input.is_action_pressed(actions):
        #get_tree().change_scene_to_file("res://menus/char_select_menu.tscn")
        SceneKeeper.load_scene(SceneKeeper.Scene.PlayerSelectScene)
