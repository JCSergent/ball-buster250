class_name BouncePad
extends Node3D

@export var bounce_force := 10
@export var bounce_sfx: SoundEffect

@onready var area_3d: Area3D = $Area3D
@onready var mesh: MeshInstance3D = $Mesh

func _ready() -> void:
    area_3d.body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D) -> void:
    if body is PlayerRigidBody:
        # var direction := global_position.direction_to(direction_marker.global_position)
        body.apply_central_impulse(Vector3.UP * bounce_force)
        AudioKeeper.play_sfx(bounce_sfx)

        var tween: Tween = create_tween()
        var surface_material: Material = mesh.mesh.surface_get_material(0)
        var og_color: Color = surface_material.albedo_color
        tween.tween_property(surface_material, "albedo_color", Color.WHITE, 0.1)
        tween.tween_property(surface_material, "albedo_color", og_color, 0.1)
