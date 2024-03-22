class_name LevelUI
extends Control

@onready var label_distance: Label = $VBoxContainer/LabelDistance

@export var player: Car

func _process(_delta: float) -> void:
	var meters: float = player.position.x / 100.0
	meters = maxf(0, meters)
	label_distance.text = "%.0f m" % meters
