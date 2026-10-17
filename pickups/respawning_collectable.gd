class_name respawning_collectable extends Node3D

const COLLECTABLE_SCENE := preload("res://pickups/collectable.tscn")

@export var collectable: Collectable

#not used but maybe?
@export var is_respawnable : bool = true

@export var respawn_time := 2.
@export var value : int =  1

@onready var timer := $Timer

var current_collectable: CollectableNode
var spawning_queued: bool = false

func _ready() -> void:
    timer.timeout.connect(spawn_new_collectable)
    spawning_queued = true
    timer.start(respawn_time)

func _process(_delta: float) -> void:
    if not current_collectable and not spawning_queued:
        print('hello')
        spawning_queued = true
        timer.start(respawn_time)
    # if not current_collectable:
    #     spawn_new_collectable()

func spawn_new_collectable() -> void:
    var new_collectable: CollectableNode = COLLECTABLE_SCENE.instantiate()
    new_collectable.init(collectable)
    current_collectable = new_collectable
    add_child(new_collectable)
    spawning_queued = false
