extends Node3D

const PLAYER_BALL = preload("res://scenes/playas/player_ball.tscn")

@onready var players: Node3D = $Players

func _ready() -> void:
    GameKeeper.connect("game_ended", show_end_screen)
    $ReusableElements/HUD/GAME_Screen.visible = false
    
    var player_1: PlayerBall = PLAYER_BALL.instantiate()
    player_1.player_id = 1
    players.add_child(player_1)
    player_1.global_position = Vector3.UP * 6
    player_1.global_position.x -= 1.

    var player_2: PlayerBall = PLAYER_BALL.instantiate()
    player_2.player_id = 2
    players.add_child(player_2)
    player_2.global_position = Vector3.UP * 6
    player_2.global_position.x += 1.

    if GameKeeper.players.get(3).is_playing:
        var player_3: PlayerBall = PLAYER_BALL.instantiate()
        player_3.player_id = 3
        players.add_child(player_3)
        player_3.global_position = Vector3.UP * 6
        player_3.global_position.x -= 2.

    if GameKeeper.players.get(4).is_playing:
        var player_4: PlayerBall = PLAYER_BALL.instantiate()
        player_4.player_id = 4
        players.add_child(player_4)
        player_4.global_position = Vector3.UP * 6
        player_4.global_position.x += 2.

    GameKeeper.new_game_started.emit(GameKeeper.players.values())

func show_end_screen():
    $ReusableElements/HUD/GAME_Screen.visible = true
    $ReusableElements/HUD/GAME_Screen/pulseObj.pulse_this()
