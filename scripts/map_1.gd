extends Node3D

const PLAYER_BALL = preload("res://scenes/playas/player_ball.tscn")

@onready var players: Node3D = $Players

func _ready() -> void:
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

    GameKeeper.new_game_started.emit(GameKeeper.players.values())
