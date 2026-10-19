class_name CollectableRigidBody
extends RigidBody3D

var collectable: CollectableNode

func _ready() -> void:
    var parent := get_parent()
    if parent is CollectableNode:
        collectable = parent
