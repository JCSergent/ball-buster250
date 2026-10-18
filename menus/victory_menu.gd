extends PanelContainer

@export var wait_time := 10.0

@onready var player_score_array: Array[Player]

@onready var timer : Timer = $Timer

@onready var winnerPanel : Sprite2D = $PLAYERS/WinnerPannel
@onready var winnerLabel : Label = $PLAYERS/WinnerLabel
@onready var winnerRect : ColorRect = $ColorRect

@onready var one_sprite : AnimatedSprite2D = $"PLAYERS/1st/selectSprite"
@onready var oneWindow : Sprite2D = $"PLAYERS/1st/playerWindow"
@onready var oneNamePlate : Sprite2D = $"PLAYERS/1st/playerNameSpace"
@onready var oneLabel : Label = $"PLAYERS/1st/PlayerLabel"
@onready var oneScore : FancyCount = $"PLAYERS/1st/FancyCount"

@onready var two_sprite : AnimatedSprite2D = $"PLAYERS/2nd/selectSprite"
@onready var twoWindow : Sprite2D = $"PLAYERS/2nd/playerWindow"
@onready var twoNamePlate : Sprite2D = $"PLAYERS/2nd/playerNameSpace"
@onready var twoLabel : Label = $"PLAYERS/2nd/PlayerLabel"
@onready var twoScore : FancyCount = $"PLAYERS/2nd/FancyCount"

@onready var three_sprite : AnimatedSprite2D = $"PLAYERS/3rd/selectSprite"
@onready var threeWindow : Sprite2D = $"PLAYERS/3rd/playerWindow"
@onready var threeNamePlate : Sprite2D = $"PLAYERS/3rd/playerNameSpace"
@onready var threeLabel : Label = $"PLAYERS/3rd/PlayerLabel"
@onready var threeScore : FancyCount = $"PLAYERS/3rd/FancyCount"

@onready var four_sprite : AnimatedSprite2D = $"PLAYERS/4th/selectSprite"
@onready var fourWindow : Sprite2D = $"PLAYERS/4th/playerWindow"
@onready var fourNamePlate : Sprite2D = $"PLAYERS/4th/playerNameSpace"
@onready var fourLabel : Label = $"PLAYERS/4th/PlayerLabel"
@onready var fourScore : FancyCount = $"PLAYERS/4th/FancyCount"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    player_score_array = GameKeeper.players.values()
    sort_scores()
    set_portraits()
    
    one_sprite.play("run")
    two_sprite.play("run")
    
    countdown_reset()

func sort_scores():
    player_score_array.sort_custom(func(p1: Player, p2: Player) -> bool: return p1.score > p2.score)

func set_portraits():
    winnerPanel.texture = load(str("res://menus/menu items/player_namebar_",player_score_array[0].id,".png"))
    winnerLabel.text = str("Player ",player_score_array[0].id," WINS!!!")
    winnerRect.color = player_score_array[0].color
    
    oneScore.show_count(player_score_array[0].score)
    one_sprite.sprite_frames = player_score_array[0].sprite
    one_sprite.speed_scale = 1.0
    oneWindow.texture = load(str("res://menus/menu items/player_card_",player_score_array[0].id,".png"))
    oneNamePlate.texture = load(str("res://menus/menu items/player_nameplate_",player_score_array[0].id,".png"))
    oneLabel.text = str("Player ",player_score_array[0].id)
    
    twoScore.show_count(player_score_array[1].score)
    two_sprite.sprite_frames = player_score_array[1].sprite
    two_sprite.speed_scale = 0.5
    twoWindow.texture = load(str("res://menus/menu items/player_card_",player_score_array[1].id,".png"))
    twoNamePlate.texture = load(str("res://menus/menu items/player_nameplate_",player_score_array[1].id,".png"))
    twoLabel.text = str("Player ",player_score_array[1].id)

func countdown_reset():
    timer.stop()
    timer.wait_time = wait_time
    timer.one_shot = true
    timer.start()
    
    await timer.timeout
    SceneKeeper.load_scene(SceneKeeper.Scene.MainMenuScene)
