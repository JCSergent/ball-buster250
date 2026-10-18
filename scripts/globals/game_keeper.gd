extends Node

# Global State of the Entire Game
# Stores what phase the game is in, and the state of every player

signal player_state_changed(player: Player)

@export var players: Dictionary[int, Player]

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

    # TODO: Go to Player Select Screen
    # game_state.phase = GameState.Phase.PlayerSelect
    # SceneKeeper.load_scene(SceneKeeper.Scene.PlayerSelectScene)

func update_score(player_id: int, value: int) -> void:
    var player: Player = players.get(player_id)
    print('value')
    print(value)
    player.score += value
    print('score')
    print(player.score)
    if player.score < 0:
        player.score = 0
    player_state_changed.emit(player)

func add_item(player_id: int, collectable: Collectable) -> void:
    var player: Player = players.get(player_id)
    player.held_item = collectable
    player_state_changed.emit(player)

func remove_item(player_id: int) -> void:
    var player: Player = players.get(player_id)
    player.held_item = null
    player_state_changed.emit(player)
    
