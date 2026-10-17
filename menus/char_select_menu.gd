extends PanelContainer

@onready var rdy_ind_P1 : Sprite2D = $PLAYERS/P1/ReadyIND
@onready var rdy_p1 : bool = false
@onready var sprite_p1 : Sprite2D = $PLAYERS/P1/selectSprite

@onready var rdy_ind_P2 : Sprite2D = $PLAYERS/P2/ReadyIND
@onready var rdy_p2 : bool = false
@onready var sprite_p2 : Sprite2D = $PLAYERS/P2/selectSprite

@onready var rdy_ind_P3 : Sprite2D = $PLAYERS/P3/ReadyIND
@onready var rdy_p3 : bool = false
@onready var sprite_p3 : Sprite2D = $PLAYERS/P3/selectSprite

@onready var rdy_ind_P4 : Sprite2D = $PLAYERS/P4/ReadyIND
@onready var rdy_p4 : bool = false
@onready var sprite_p4 : Sprite2D = $PLAYERS/P4/selectSprite

@onready var rdy_all : bool = false

@onready var rat_sprite = preload("res://art/sprites/lilRatGirl.png")
@onready var frog_sprite = preload("res://art/sprites/lilRatGirl_2.png")
@onready var cat_sprite = preload("res://art/sprites/lilRatGirl_3.png")
@onready var bunny_sprite = preload("res://art/sprites/lilRatGirl_4.png")

@onready var sprite_array : Array = [rat_sprite, frog_sprite, cat_sprite, bunny_sprite]

var player_1_sprite_id: int = 0
var player_2_sprite_id: int = 0
var player_3_sprite_id: int = 0
var player_4_sprite_id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    sprite_p1.texture = sprite_array[0]
    sprite_p2.texture = sprite_array[1]
    sprite_p3.texture = sprite_array[2]
    sprite_p4.texture = sprite_array[3]
    
    !rdy_p1
    !rdy_p2
    !rdy_all

    !rdy_ind_P1.visible
    !rdy_ind_P2.visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if rdy_p1 && rdy_p2:
        rdy_all = true
    else:
        !rdy_all
    
    if rdy_all:
        set_ingame_sprites()
        SceneKeeper.load_scene(SceneKeeper.Scene.GameScene)

func _input(event: InputEvent) -> void:
# all =================================================================
    if event.is_action_pressed("item_p1") || event.is_action_pressed("item_p2") :
        SceneKeeper.load_scene(SceneKeeper.Scene.MainMenuScene)
  
# P1 ================================================================     
    elif event.is_action_pressed("jump_p1"):
        toggle_player_ready("P1")
        
    elif event.is_action_pressed("forward_p1"):
        if player_1_sprite_id == 3:
            player_1_sprite_id = 0
        else:
           player_1_sprite_id += 1 
    
        sprite_p1.texture = sprite_array[player_1_sprite_id]       
    
    elif event.is_action_pressed("back_p1"):
        if player_1_sprite_id == 0:
            player_1_sprite_id = 3
        else:
           player_1_sprite_id -= 1 
    
        sprite_p1.texture = sprite_array[player_1_sprite_id] 

# P2 ===================================================================     
    elif event.is_action_pressed("jump_p2"):
        toggle_player_ready("P2")
        
    elif event.is_action_pressed("forward_p2"):
        if player_2_sprite_id == 3:
            player_2_sprite_id = 0
        else:
           player_2_sprite_id += 1 
    
        sprite_p2.texture = sprite_array[player_2_sprite_id]       
    
    elif event.is_action_pressed("back_p2"):
        if player_2_sprite_id == 0:
            player_2_sprite_id = 3
        else:
           player_2_sprite_id -= 1 
    
        sprite_p2.texture = sprite_array[player_2_sprite_id] 

func toggle_player_ready(player : String):
    match player:
        "P1":
            rdy_p1 = !rdy_p1
            rdy_ind_P1.visible = !rdy_ind_P1.visible
            
        "P2":
            rdy_p2 = !rdy_p2
            rdy_ind_P2.visible = !rdy_ind_P2.visible
            
func set_ingame_sprites():
    GameKeeper.players.get(1).sprite = sprite_array[player_1_sprite_id]
    GameKeeper.players.get(2).sprite = sprite_array[player_2_sprite_id]
    #GameKeeper.players.get(3).texture = sprite_array[player_3_sprite_id]
    #GameKeeper.players.get(4).texture = sprite_array[player_4_sprite_id]
