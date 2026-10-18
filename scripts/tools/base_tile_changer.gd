@tool
extends MeshInstance3D

@export var block_type: BlockType:
    set(new_type):
        block_type = new_type
        on_block_type_change(new_type)

@export_group("Configuration")
@export var block_materials: Dictionary[BlockType, StandardMaterial3D]

enum BlockType { Grass1, Grass2, Grass3, Grass4, Grass5, Grass6, Dirt1, Dirt2, Sand1, Stone1, Stone2, Wood1, Grey1, Grey2 }

func on_block_type_change(new_type: BlockType) -> void:
    if block_materials.has(new_type):
        mesh.material = block_materials.get(new_type)
