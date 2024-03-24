class_name LevelUI
extends Control

@onready var label_distance: Label = $VBoxContainer/LabelDistance
@onready var progress_bar_fuel: ProgressBar = $VBoxContainer/HBoxContainer/ProgressBarFuel

@export var player: Car

var stylebox_fill: StyleBoxFlat
var fuel_gradient: Gradient = Gradient.new()

func _ready() -> void:
	stylebox_fill = progress_bar_fuel.get_theme_stylebox("fill").duplicate()
	progress_bar_fuel.add_theme_stylebox_override("fill", stylebox_fill)
	
	fuel_gradient.set_color(0, Color(0.89, 0.176, 0.176))
	fuel_gradient.set_color(1, stylebox_fill.bg_color)
	fuel_gradient.add_point(0.5, Color(0.89, 0.878, 0.176))

func _process(_delta: float) -> void:
	var meters: float = player.position.x / Level.PX_TO_M
	meters = maxf(0, meters)
	label_distance.text = "%.0f m" % meters

	progress_bar_fuel.value = player.fuel
	stylebox_fill.bg_color = fuel_gradient.sample(player.fuel)
