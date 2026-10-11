class_name HUD
extends CanvasLayer

@onready var p1_score := $P1/Score
@onready var p1_item: TextureRect = $P1/StoredItem

func _ready() -> void:
    EventBus.update_score_hud.connect(update_hud)
    update_hud()

func update_hud() -> void:
    p1_score.text = str(Scorekeeper.p1_score)
    if Scorekeeper.p1_item:
        p1_item.texture = Scorekeeper.p1_item.texture
    else:
        p1_item.texture = null
