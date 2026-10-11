extends Node

signal add_score(value : int)

signal update_score_hud()

## NOTES:
#some examples from a kind soul on discord

## EventBus.gd
#extends Node
#
#signal request_teleport(target_position: Vector2)
#
#

## Teleporter.gd
#extends Area2D
#
#@export var teleport_destination: Vector2 = Vector2(100, 100)
#
#func _ready() -> void:
	#body_entered.connect(_on_body_entered)
#
#func _on_body_entered(body: Node2D) -> void:
	#if body is Player:
		#EventBus.request_teleport.emit(teleport_destination)
#
#
## Player.gd
#extends CharacterBody2D
#class_name Player
#
#func _ready() -> void:
	#EventBus.request_teleport.connect(_on_teleport_requested)
#
#func _on_teleport_requested(target_pos: Vector2) -> void:
	#global_position = target_pos
