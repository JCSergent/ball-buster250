class_name HUD
extends CanvasLayer

@export var number_sprites: Array[Texture2D]

@onready var p1_score := $P1/Score
@onready var p1_item: TextureRect = $P1/StoredItem

@onready var p2_score := $P2/Score
@onready var p2_item: TextureRect = $P2/StoredItem

func _ready() -> void:
    GameKeeper.player_state_changed.connect(update_player_hud)

func update_player_hud(player: Player) -> void:
    pass
    # if player.id == 1:
    #     p1_score.text = str(player.score)
    #     if player.held_item:
    #         p1_item.texture = player.held_item.texture
    #     else:
    #         p1_item.texture = null
    # elif player.id == 2:
    #     p2_score.text = str(player.score)
    #     if player.held_item:
    #         p2_item.texture = player.held_item.texture
    #     else:
    #         p2_item.texture = null
    # TODO: do the other players :)
    # elif player.id == 3:
    #     p3_score.text = str(player.score)
    #     if player.held_item:
    #         p3_item.texture = player.held_item.texture
    #     else:
    #         p3_item.texture = null
    # elif player.id == 4:
    #     p4_score.text = str(player.score)
    #     if player.held_item:
    #         p4_item.texture = player.held_item.texture
    #     else:
    #         p4_item.texture = null
