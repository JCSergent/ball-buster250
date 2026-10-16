extends Node3D
class_name sunsucc

@onready var travel_nodes : Array = []
@onready var swap_timer : Timer = $Timer

@export var base_speed : float = 4.0

@onready var current_speed : float

@onready var swap_threshold := 1.0
@export var time_until_swap : float = 3.0

@onready var current_target : Node3D

@onready var dest_reached : bool = false

func _ready() -> void:
    current_speed = base_speed
    dest_reached = false
    travel_nodes.append_array(get_tree().get_nodes_in_group("TravelNodes"))
    
    if travel_nodes.size() > 1:
        print("NODES COLLECTED!")
        print('travel_nodes')
        current_target = pick_new_node()
    else:
        push_error("insufficent travel nodes :(")
    
func _process(delta: float) -> void:
    travel_to_node(delta)

func travel_to_node(delta):
    if not dest_reached:
        if position.distance_to(current_target.position) > swap_threshold:
            position = position.move_toward(current_target.position, delta * current_speed)
        else:
            dest_reached = true
            print("Destination reached: ", current_target)
            swap_timer.stop()
            swap_timer.wait_time = time_until_swap
            swap_timer.one_shot = true
            print("Starting swap timer...")
            swap_timer.start()

            await swap_timer.timeout

            print("Time to pick a new node!")
            current_target = pick_new_node()
            dest_reached = false

func pick_new_node():
    var n = travel_nodes.pick_random()
    print("PICKING NEW NODE:", n)
    return n
