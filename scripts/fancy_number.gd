class_name FancyNumber
extends Node2D

@export var number_sprites: Array[Sprite2D]

func show_number(number: int) -> void:
    # print(str(number))
    if number >= 0:
        for i in number_sprites.size():
            if i == number:
                number_sprites.get(i).visible = true
            else:
                number_sprites.get(i).visible = false
    else:
        for i in number_sprites.size():
            number_sprites.get(i).visible = false
