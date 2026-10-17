class_name SunSucc
extends Node3D

@export var travel_nodes : Array[PathFollow3D] = []


@export var zone_speed : float = 0.02
@export var change_zone_speed : float = 8.

@export var swap_threshold := 0.2
@export var time_until_swap : float = 10.

@onready var collect_area: Area3D = $CollectArea
@onready var swap_timer : Timer = $Timer

var current_target : PathFollow3D
var changing_zone: bool = false
var current_zone_duration: float = 0.

func _ready() -> void:
    # dest_reached = false
    # travel_nodes.append_array(get_tree().get_nodes_in_group("TravelNodes"))
    collect_area.area_entered.connect(on_area_entered)
    
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

func pick_new_node() -> PathFollow3D:
    var new_node: PathFollow3D = current_target

    while new_node == current_target:
        new_node = travel_nodes.pick_random()
        
    print("PICKING NEW NODE:", new_node)
    return new_node

func on_area_entered(area: Area3D) -> void:
    print('hello')
    if area is BulletArea and area.bullet:
        var bullet: Bullet = area.bullet
        print(bullet.fired_by_player)
        GameKeeper.update_score(bullet.fired_by_player, 1)
        bullet.queue_free()
