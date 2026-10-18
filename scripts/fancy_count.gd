class_name FancyCount
extends Node2D

# NOTE: Only supports 3 digits or less

@onready var hundred: FancyNumber = $Hundred
@onready var ten: FancyNumber = $Ten
@onready var one: FancyNumber = $One

func show_count(number: int) -> void:
    var number_str: String = str(number)
    if number < 100:
        hundred.show_number(-1)
    else:
        hundred.show_number(int(number_str[0]))
    

    if number < 10:
        ten.show_number(-1)
    elif number < 100:
        ten.show_number(int(number_str[0]))
    else:
        ten.show_number(int(number_str[0]))


    if number < 10:
        one.show_number(int(number_str[0]))
    elif number < 100:
        one.show_number(int(number_str[1]))
    else:
        one.show_number(int(number_str[2]))
        
