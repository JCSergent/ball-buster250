class_name StarSpawnMaster
extends Node3D

@export var min_spawn_time: float = 2.
@export var max_spawn_time: float = 3.
@export var max_stars: int = 100

@export var big_boi_rate: int = 10

@export var players: Node3D

@onready var respawn_timer : Timer = $Timer

@onready var bottom_left: Node3D = $BottomLeft
@onready var bottom_right: Node3D = $BottomRight
@onready var top_left: Node3D = $TopLeft
@onready var top_right: Node3D = $TopRight


var count_since_big_boi: int = 0

func _ready() -> void:
    respawn_timer.timeout.connect(spawn_new_star)
    respawn_timer.start(randf_range(min_spawn_time, max_spawn_time))

func spawn_new_star() -> void:

    var star_count: int = 0
    for child in bottom_left.get_children():
        if child is StarSpawner and not child.can_spawn():
            star_count += 1
    for child in bottom_right.get_children():
        if child is StarSpawner and not child.can_spawn():
            star_count += 1
    for child in top_left.get_children():
        if child is StarSpawner and not child.can_spawn():
            star_count += 1
    for child in top_right.get_children():
        if child is StarSpawner and not child.can_spawn():
            star_count += 1

    if star_count > max_stars:
        respawn_timer.start(randf_range(min_spawn_time, max_spawn_time))
        return
        

    # Soft quadrants by where the ones with the least amount of players
    var quadrants: Dictionary[Node3D, int] = {}
    quadrants.set(bottom_left, 0)
    quadrants.set(bottom_right, 0)
    quadrants.set(top_left, 0)
    quadrants.set(top_right, 0)

    for player in players.get_children():
        if player is PlayerBall:
            var is_left: bool = player.rigid_body_3d.global_position.x < 0
            var is_top: bool = player.rigid_body_3d.global_position.z < 0

            if is_left and is_top:
                quadrants.set(top_left, quadrants.get(top_left) + 1)
            elif is_left and not is_top:
                quadrants.set(bottom_left, quadrants.get(bottom_left) + 1)
            elif not is_left and is_top:
                quadrants.set(top_right, quadrants.get(top_right) + 1)
            elif not is_left and not is_top:
                quadrants.set(bottom_right, quadrants.get(bottom_right) + 1)

    # Sort keys in descending order of values.
    var quads: Array[Node3D] = quadrants.keys()
    quads.shuffle()
    quads.sort_custom(func(x: Node3D, y: Node3D) -> bool: return quadrants.get(x) < quadrants.get(y))

    for quad in quads:
        if spawn_in_quad(quad):
            break
            
    respawn_timer.start(randf_range(min_spawn_time, max_spawn_time))

func spawn_in_quad(quadrant: Node3D) -> bool:
    var children: Array[Node] = quadrant.get_children().duplicate()
    children.shuffle()

    for child in children:
        if child is StarSpawner and child.can_spawn():
            if count_since_big_boi > big_boi_rate and (randi() % 4 == 1):
                child.spawn_star(5)
                count_since_big_boi = 0
            else:
                child.spawn_star()
                count_since_big_boi += 1
            return true
        
    return false
