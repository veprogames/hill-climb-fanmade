class_name LevelUI
extends Control

@onready var label_distance: Label = $VBoxContainer/LabelDistance
@onready var progress_bar_fuel: ProgressBar = $VBoxContainer/HBoxContainer/ProgressBarFuel

@export var player: Car

func _process(_delta: float) -> void:
	var meters: float = player.position.x / Level.PX_TO_M
	meters = maxf(0, meters)
	label_distance.text = "%.0f m" % meters
	progress_bar_fuel.value = player.fuel
