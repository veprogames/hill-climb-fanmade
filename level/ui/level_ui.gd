class_name LevelUI
extends Control

@onready var label_distance: Label = $LabelDistance
@onready var label_highscore: Label = $HBoxContainerHighscore/LabelHighscore
@onready var fuel_bar: FuelBar = $VBoxContainer/HBoxContainer/FuelBar
@onready var pedal_l: Pedal = $PedalL
@onready var pedal_r: Pedal = $PedalR
@onready var gauge_speed: Gauge = $GaugeSpeed
@onready var low_fuel_alarm: LowFuelAlarm = $LowFuelAlarm

@export var level: Level
@export var player: Car
# used for next fuel
@export var collectible_spawner: CollectibleSpawner

var highscore: float

func _ready() -> void:
	highscore = get_highscore()
	
	player.gas_changed.connect(_on_player_gas_changed)
	player.brake_changed.connect(_on_player_brake_changed)
	player.low_fuel_reached.connect(_on_player_low_fuel_reached)
	player.refueled.connect(_on_player_refueled)
	player.fuel_depleted.connect(_on_player_fuel_depleted)

func _process(_delta: float) -> void:
	var meters: float = player.highest_x / Level.PX_TO_M
	meters = maxf(0, meters)
	label_distance.text = "%s m" % F.F(meters)
	
	var highscore_displayed: float = maxf(meters, highscore)
	label_highscore.text = "%s m" % F.F(highscore_displayed)

	var next_fuel_m: float = get_distance_to_next_fuel_in_meters()
	fuel_bar.value = player.fuel
	fuel_bar.show_next_fuel = next_fuel_m > 0 and next_fuel_m <= 99
	fuel_bar.next_fuel_value = next_fuel_m
	
	var meters_per_second: float = absf(player.linear_velocity.x / Level.PX_TO_M)
	gauge_speed.value = meters_per_second / 50.0
	gauge_speed.text = "%.0f" % absf(meters_per_second)
	
func get_distance_to_next_fuel_in_meters() -> float:
	var closest_instance: FuelCollectible = collectible_spawner.get_closest_fuel()
	var x: float
	
	if closest_instance != null:
		x = closest_instance.position.x
	else:
		x = collectible_spawner.get_next_fuel()
	
	return (x - player.position.x) / Level.PX_TO_M

func get_highscore() -> float:
	return Game.save.highscores.get_highscore(level.data)

func _on_player_gas_changed(new_state: bool) -> void:
	if new_state:
		pedal_r.activate()
	else:
		pedal_r.deactivate()

func _on_player_brake_changed(new_state: bool) -> void:
	if new_state:
		pedal_l.activate()
	else:
		pedal_l.deactivate()

func _on_player_low_fuel_reached() -> void:
	low_fuel_alarm.activate()

func _on_player_fuel_depleted() -> void:
	low_fuel_alarm.deactivate()

func _on_player_refueled(_was_out_of: bool) -> void:
	low_fuel_alarm.deactivate()
