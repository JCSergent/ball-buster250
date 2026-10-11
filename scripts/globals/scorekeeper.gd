extends Node

@onready var p1_score : int = 0
@onready var p1_item: Collectable = null

func _ready() -> void:
    p1_score = 0
    EventBus.update_score_hud.emit()

func add_score(value : int):
    p1_score += value
    EventBus.update_score_hud.emit()

func add_item(collectable: Collectable) -> void:
    p1_item = collectable
    EventBus.update_score_hud.emit()

func remove_item() -> void:
    p1_item = null
    EventBus.update_score_hud.emit()
