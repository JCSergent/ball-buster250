class_name BulletArea
extends Area3D

var bullet: Bullet

func _ready() -> void:
    var parent := get_parent()
    if parent is Bullet:
        bullet = parent
