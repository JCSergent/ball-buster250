class_name Player
extends Resource

@export var id: int = 1 # 1, 2, 3, or 4
@export var color: Color
@export var sprite: SpriteFrames

var is_playing: bool = true
var score: int = 0
var held_item: Collectable

var string_id: String:
    get:
        return 'p' + str(id)
