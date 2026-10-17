class_name StarSpawner
extends Node3D

const COLLECTABLE_SCENE := preload("res://pickups/collectable.tscn")

@export var point_1_star: Collectable
@export var point_5_star: Collectable
@export var point_10_star: Collectable

@export var position_offset: float = 2.

#not used but maybe?
@export var is_respawnable : bool = true

@export var respawn_time := 2.
@export var value : int =  1

@onready var timer := $Timer

var current_collectable: CollectableNode
var spawning_queued: bool = false

func can_spawn() -> bool:
    return not current_collectable

func spawn_star(amount: int = 1) -> void:
    var new_collectable: CollectableNode = COLLECTABLE_SCENE.instantiate()

    if amount == 5:
        new_collectable.init(point_5_star)
    elif amount == 10:
        new_collectable.init(point_10_star)
    else:
        new_collectable.init(point_1_star)
    current_collectable = new_collectable
    add_child(new_collectable)


    var x_dir: int = 1 
    if randi() & 2 == 0:
        x_dir = -1

    current_collectable.global_position.y += 15
    current_collectable.global_position.x += 8 * x_dir

    current_collectable.position.x += randf_range(-position_offset, position_offset)
    current_collectable.position.y += randf_range(-position_offset, position_offset)
    spawning_queued = false

    await get_tree().process_frame
    current_collectable.fling(Vector3(-0.5 * x_dir, -0.5, 0) * 20)
    # current_collectable.rigid_body_3d.apply_central_impulse(Vector3(-0.5, -0.5, 0) * 20)
