class_name HUD
extends CanvasLayer

@export var number_sprites: Array[Texture2D]

@onready var p1_score: FancyCount = %P1Score
@onready var p2_score: FancyCount = %P2Score
@onready var p3_score: FancyCount = %P3Score
@onready var p4_score: FancyCount = %P4Score

@onready var p1_sprite: Sprite2D = %P1Sprite
@onready var p2_sprite: Sprite2D = %P2Sprite
@onready var p3_sprite: Sprite2D = %P3Sprite
@onready var p4_sprite: Sprite2D = %P4Sprite

@onready var p3_hud: Control = $P3
@onready var p4_hud: Control = $P4

func _ready() -> void:
    GameKeeper.player_state_changed.connect(update_player_hud)
    GameKeeper.new_game_started.connect(on_new_game_start)

func on_new_game_start(players: Array[Player]) -> void:
    for player in players:
        if player.id == 1:
            p1_score.show_count(0)
            p1_sprite.texture = player.sprite.get_frame_texture('run', 0)
        elif player.id == 2:
            p2_score.show_count(0)
            p2_sprite.texture = player.sprite.get_frame_texture('run', 0)
        elif player.id == 3:
            if player.is_playing:
                p3_score.show_count(0)
                p3_sprite.texture = player.sprite.get_frame_texture('run', 0)
            else:
                p3_hud.visible = false

        elif player.id == 4:
            if player.is_playing:
                p4_score.show_count(0)
                p4_sprite.texture = player.sprite.get_frame_texture('run', 0)
            else:
                p4_hud.visible = false

func update_player_hud(player: Player) -> void:
    if player.id == 1:
        p1_score.show_count(player.score)
    elif player.id == 2:
        p2_score.show_count(player.score)
    elif player.id == 3:
        p3_score.show_count(player.score)
    elif player.id == 4:
        p4_score.show_count(player.score)
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
