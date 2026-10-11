extends Node

# Global State of the Entire Game
# Stores what phase the game is in, and the state of every player

signal player_state_changed(player: Player)

var game_state: GameState

var players: Dictionary[int, Player]

func _ready() -> void:
    game_state = GameState.new()
    reset_game()

func reset_game() -> void:
    players.clear()
    players.set(1, Player.create(1))
    players.set(2, Player.create(2))
    players.set(3, Player.create(3))
    players.set(4, Player.create(4))
    game_state.phase = GameState.Phase.PlayerSelect
    # SceneKeeper.load_scene(SceneKeeper.Scene.PlayerSelectScene)

func update_score(player_id: int, value: int) -> void:
    var player: Player = players.get(player_id)
    player.score = value
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
