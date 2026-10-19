extends PanelContainer

@onready var timer : Timer = $Timer
@export var wait_time := 3.0

@onready var allReadyInd : Label = $PLAYERS/Ready

@onready var rdy_ind_P1 : Sprite2D = $PLAYERS/P1/ReadyIND
@onready var rdy_p1 : bool = false
@onready var sprite_p1 : AnimatedSprite2D = $PLAYERS/P1/selectSprite

@onready var rdy_ind_P2 : Sprite2D = $PLAYERS/P2/ReadyIND
@onready var rdy_p2 : bool = false
@onready var sprite_p2 : AnimatedSprite2D = $PLAYERS/P2/selectSprite

@onready var rdy_ind_P3 : Sprite2D = $PLAYERS/P3/ReadyIND
@onready var rdy_p3 : bool = false
@onready var sprite_p3 : AnimatedSprite2D = $PLAYERS/P3/selectSprite

@onready var rdy_ind_P4 : Sprite2D = $PLAYERS/P4/ReadyIND
@onready var rdy_p4 : bool = false
@onready var sprite_p4 : AnimatedSprite2D = $PLAYERS/P4/selectSprite

@onready var rdy_all : bool = false

@onready var rat_sprite = preload("res://art/animatedsprites/rat_frames.tres")
@onready var frog_sprite = preload("res://art/animatedsprites/frog_frames.tres")
@onready var cat_sprite = preload("res://art/animatedsprites/cat_frames.tres")
@onready var bunny_sprite = preload("res://art/animatedsprites/bunny_frames.tres")


@onready var sprite_array : Array = [rat_sprite, frog_sprite, cat_sprite, bunny_sprite]

var player_1_sprite_id: int = 0
var player_2_sprite_id: int = 1
var player_3_sprite_id: int = 2
var player_4_sprite_id: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    allReadyInd.visible = false
    
    sprite_p1.sprite_frames = sprite_array[0]
    sprite_p1.speed_scale = 0.0
    
    sprite_p2.sprite_frames = sprite_array[1]
    sprite_p2.speed_scale = 0.0
    
    sprite_p3.sprite_frames = sprite_array[2]
    sprite_p3.speed_scale = 0.0
    
    sprite_p4.sprite_frames = sprite_array[3]
    sprite_p4.speed_scale = 0.0
    
    !rdy_p1
    !rdy_p2
    !rdy_all

    !rdy_ind_P1.visible
    !rdy_ind_P2.visible
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
# P1 ===================================================================     
    if Input.is_action_just_pressed("shoot_p1") || Input.is_action_just_pressed("charge_p1"):
        toggle_player_ready("P1")
        $PLAYERS/P1/selectSprite/pulseObj.pulse_this()
        $PLAYERS/P1/ReadyIND/pulseObj.pulse_this()
    
    elif Input.is_action_just_pressed("forward_p1"):
        if !rdy_p1:
            $PLAYERS/P1/selectSprite/pulseObj.pulse_this()
            if player_1_sprite_id == 3:
                player_1_sprite_id = 0
            else:
                player_1_sprite_id += 1 
        
        
        sprite_p1.sprite_frames = sprite_array[player_1_sprite_id]       
    
    elif Input.is_action_just_pressed("back_p1"):
        if !rdy_p1:
            $PLAYERS/P1/selectSprite/pulseObj.pulse_this()
            if player_1_sprite_id == 0:
                player_1_sprite_id = 3
            else:
                player_1_sprite_id -= 1 
    
        sprite_p1.sprite_frames = sprite_array[player_1_sprite_id] 

# P2 ===================================================================     
    elif Input.is_action_just_pressed("shoot_p2") || Input.is_action_just_pressed("charge_p2"):
        toggle_player_ready("P2")
        $PLAYERS/P2/selectSprite/pulseObj.pulse_this()
        $PLAYERS/P2/ReadyIND/pulseObj.pulse_this()
        
        
    elif Input.is_action_just_pressed("forward_p2"):
        if !rdy_p2:
            $PLAYERS/P2/selectSprite/pulseObj.pulse_this()
            if player_2_sprite_id == 3:
                player_2_sprite_id = 0
            else:
                player_2_sprite_id += 1 
    
        sprite_p2.sprite_frames = sprite_array[player_2_sprite_id]    
        
    
    elif Input.is_action_just_pressed("back_p2"):
        if !rdy_p2:
            $PLAYERS/P2/selectSprite/pulseObj.pulse_this()
            if player_2_sprite_id == 0:
                player_2_sprite_id = 3
            else:
                player_2_sprite_id -= 1 
    
        sprite_p2.sprite_frames = sprite_array[player_2_sprite_id]
        
#sprite playing ================ 
    if rdy_p1:
        sprite_p1.speed_scale = 1.0
    else:
        sprite_p1.speed_scale = 0.0
        
    if rdy_p2:
        sprite_p2.speed_scale = 1.0
    else:
        sprite_p2.speed_scale = 0.0

    #if rdy_p3:
        #sprite_p3.speed_scale = 1.0
    #elif !rdy_p3:
        #sprite_p3.speed_scale = 0.0

func toggle_player_ready(player : String):
    match player:
        "P1":
            rdy_p1 = !rdy_p1
            rdy_ind_P1.visible = !rdy_ind_P1.visible
            sprite_p1.play()
            
        "P2":
            rdy_p2 = !rdy_p2
            rdy_ind_P2.visible = !rdy_ind_P2.visible
            sprite_p2.play()
            
    if rdy_p1 && rdy_p2:
        allReadyInd.visible = true
        $PLAYERS/Ready/pulseObj.pulse_this()
        timer.stop()
        timer.wait_time = wait_time
        timer.one_shot = true
        timer.start()
    
        await timer.timeout
        
        set_ingame_sprites()
        SceneKeeper.load_scene(SceneKeeper.Scene.GameScene)
        
    else:
        timer.stop()
        allReadyInd.visible = false
            
func set_ingame_sprites():
    GameKeeper.players.get(1).sprite = sprite_array[player_1_sprite_id]
    GameKeeper.players.get(2).sprite = sprite_array[player_2_sprite_id]
    #GameKeeper.players.get(3).texture = sprite_array[player_3_sprite_id]
    #GameKeeper.players.get(4).texture = sprite_array[player_4_sprite_id]
