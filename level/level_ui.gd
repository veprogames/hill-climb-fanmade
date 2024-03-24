class_name LevelUI
extends Control

@onready var label_distance: Label = $LabelDistance
@onready var progress_bar_fuel: ProgressBar = $VBoxContainer/HBoxContainer/ProgressBarFuel
@onready var label_next_fuel: Label = $VBoxContainer/HBoxContainer/ProgressBarFuel/LabelNextFuel

@export var player: Car
# used for next fuel
@export var collectible_spawner: CollectibleSpawner

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
	label_distance.text = "%s m" % F.F(meters)

	progress_bar_fuel.value = player.fuel
	stylebox_fill.bg_color = fuel_gradient.sample(player.fuel)
	
	var next_fuel_m: float = get_distance_to_next_fuel_in_meters()
	if next_fuel_m > 0 and next_fuel_m <= 99:
		label_next_fuel.text = "%s m" % F.F(next_fuel_m)
	else:
		label_next_fuel.text = ""
	
	
func get_distance_to_next_fuel_in_meters() -> float:
	var closest_instance: FuelCollectible = collectible_spawner.get_closest_fuel()
	var x: float
	
	if closest_instance != null:
		x = closest_instance.position.x
	else:
		x = collectible_spawner.get_next_fuel()
	
	return (x - player.position.x) / Level.PX_TO_M
