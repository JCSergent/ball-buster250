class_name FancyCount
extends Node2D

# NOTE: Only supports 3 digits or less

@export var default_count: int = 0

@onready var hundred: FancyNumber = $Hundred
@onready var ten: FancyNumber = $Ten
@onready var one: FancyNumber = $One

@onready var left: Node2D = $Left
@onready var center_left: Node2D = $CenterLeft
@onready var center: Node2D = $Center
@onready var center_right: Node2D = $CenterRight
@onready var right: Node2D = $Right

func _ready() -> void:
    show_count(default_count)

func show_count(number: int) -> void:
    var number_str: String = str(number)

    if number < 0:
        hundred.show_number(-1)
        ten.show_number(-1)
        one.show_number(-1)
    elif number < 10:
        hundred.show_number(int(number_str[0]))
        hundred.global_position = center.global_position
        ten.show_number(-1)
        one.show_number(-1)
    elif number < 100:
        hundred.show_number(int(number_str[0]))
        hundred.global_position = center_left.global_position
        ten.show_number(int(number_str[1]))
        ten.global_position = center_right.global_position
        one.show_number(-1)
    else:
        hundred.show_number(int(number_str[0]))
        hundred.global_position = left.global_position
        ten.show_number(int(number_str[1]))
        ten.global_position = center.global_position
        one.show_number(int(number_str[2]))
        one.global_position = right.global_position
