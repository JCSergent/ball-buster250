extends PanelContainer


@onready var rdy_ind_P1 : Sprite2D = $PLAYERS/P1/ReadyIND
@onready var rdy_p1 : bool = false

@onready var rdy_ind_P2 : Sprite2D = $PLAYERS/P2/ReadyIND
@onready var rdy_p2 : bool = false

@onready var rdy_all : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if rdy_p1 && rdy_p2:
        rdy_all
    else:
        !rdy_all
    
    if rdy_all:
        get_tree().change_scene_to_file("res://scenes/test_map_1.tscn")

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("esc"):
        get_tree().quit()
        
    elif event.is_action_pressed("jump_p1"):
        toggle_player_ready("P1")
        
    elif event.is_action_pressed("jump_p2"):
        toggle_player_ready("P2")
 
func toggle_player_ready(player : String):
    match player:
        "P1":
            rdy_p1 = !rdy_p1
            rdy_ind_P1.visible = !rdy_ind_P1.visible
            
        "P2":
            rdy_p2 = !rdy_p2
            rdy_ind_P2.visible = !rdy_ind_P2.visible
