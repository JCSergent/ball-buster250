class_name GameState
extends Resource

@export var phase: Phase 
@export var num_of_players: int = 2

enum Phase { PlayerSelect, InGame }
