extends Node

# Global State of the Entire Game
# Stores what phase the game is in, and the state of every player

signal player_state_changed(player: Player)
signal new_game_started(players: Array[Player])
signal game_ended()

@onready var timer : Timer = $Timer

@export var players: Dictionary[int, Player]


@export var win_score : int = 5

var game_state: GameState

var is_two_player: bool = true

func _ready() -> void:
    game_state = GameState.new()
    reset_game()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("esc"):
        get_tree().quit()

func reset_game() -> void:
    for player: Player in players.values():
        player.reset_state()

func update_score(player_id: int, value: int) -> void:
    var player: Player = players.get(player_id)
    player.score += value
    if player.score < 0:
        player.score = 0
    player_state_changed.emit(player)
    
    if player.score >= win_score:
        end_game()

func add_item(player_id: int, collectable: Collectable) -> void:
    var player: Player = players.get(player_id)
    player.held_item = collectable
    player_state_changed.emit(player)

func remove_item(player_id: int) -> void:
    var player: Player = players.get(player_id)
    player.held_item = null
    player_state_changed.emit(player)
    
func end_game():
    game_ended.emit()
    get_tree().paused = true
    
    timer.stop()
    timer.wait_time = 3.0
    timer.one_shot = true
    timer.start()
    
    await timer.timeout
    get_tree().paused = false
    SceneKeeper.load_scene(SceneKeeper.Scene.VictoryScene)
