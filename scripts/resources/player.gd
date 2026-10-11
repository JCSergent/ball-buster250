class_name Player
extends Resource

@export var id: int = 1 # 1, 2, 3, or 4
@export var score: int = 0
@export var held_item: Collectable

@export var color: Color
@export var sprite: Texture2D

static func create(_id: int) -> Player:
    var player := Player.new()
    player.id = _id
    return player
