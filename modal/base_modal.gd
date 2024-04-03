class_name BaseModal
extends Control

signal opened
signal closed

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var panel: Panel = $Panel

func _ready() -> void:
	opened.emit()
	
	panel.pivot_offset = panel.size / 2.0
	
	animation_player.play("open")

func close() -> void:
	closed.emit()
	queue_free()
