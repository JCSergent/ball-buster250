extends Node3D
class_name sunsucc

@export var travel_nodes : Array[PathFollow3D] = []
@onready var swap_timer : Timer = $Timer

@export var zone_speed : float = 0.02
@export var change_zone_speed : float = 8.

@onready var swap_threshold := 0.2
@export var time_until_swap : float = 10.

var current_target : PathFollow3D
var changing_zone: bool = false
var current_zone_duration: float = 0.

func _ready() -> void:
    # dest_reached = false
    # travel_nodes.append_array(get_tree().get_nodes_in_group("TravelNodes"))
    
    if travel_nodes.size() > 0:
        print("NODES COLLECTED!")
        print('travel_nodes')
        current_target = pick_new_node()
        call_deferred("reparent", current_target)
        changing_zone = true
    else:
        push_error("insufficent travel nodes :(")
    
func _process(delta: float) -> void:
    if not changing_zone:
        current_zone_duration += delta

        if current_zone_duration < time_until_swap:
            current_target.progress_ratio += zone_speed * delta
        else:
            current_target = pick_new_node()
            reparent(current_target)
            changing_zone = true
    else:
        global_position = global_position.move_toward(current_target.global_position, change_zone_speed * delta)

        if global_position.distance_to(current_target.global_position) < swap_threshold:
            print('stop zone')
            global_position = current_target.global_position
            changing_zone = false
            current_zone_duration = 0.

# func travel_to_node(delta):
#     if not dest_reached:
#         if position.distance_to(current_target.position) > swap_threshold:
#             position = position.move_toward(current_target.position, delta * change_zone_speed)
#         else:
#             dest_reached = true
#             print("Destination reached: ", current_target)
#             swap_timer.stop()
#             swap_timer.wait_time = time_until_swap
#             swap_timer.one_shot = true
#             print("Starting swap timer...")
#             swap_timer.start()
#
#             await swap_timer.timeout
#
#             print("Time to pick a new node!")
#             current_target = pick_new_node()
#             # dest_reached = false

func pick_new_node() -> PathFollow3D:
    var new_node: PathFollow3D = current_target

    while new_node == current_target:
        new_node = travel_nodes.pick_random()
        
    print("PICKING NEW NODE:", new_node)
    return new_node
