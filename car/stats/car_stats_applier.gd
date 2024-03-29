class_name CarStatsApplier
extends Node2D

const BASE_ACCELERATION: float = 80_000.0
const BASE_AIR_ACCELERATION: float = 150_000.0
const BASE_DOWNWARD_PRESSURE: float = 1_250.0

@export var car: Car

var garage: SaveGameGarage

var engine_acceleration: float = BASE_ACCELERATION
var air_rotation_speed: float = BASE_AIR_ACCELERATION
var fuel_capacity: float = 30.0

func _ready() -> void:
	garage = Game.save.garage
	
	if !car.is_node_ready():
		await car.ready
	
	apply_stats()

func apply_stats() -> void:
	var effects: Dictionary = garage.get_all_effects()
	
	engine_acceleration = BASE_ACCELERATION * effects[UpgradeItemDefinition.StatType.EngineAcceleration]
	fuel_capacity = effects[UpgradeItemDefinition.StatType.FuelCapacity]
	air_rotation_speed = BASE_AIR_ACCELERATION * effects[UpgradeItemDefinition.StatType.AirRoationSpeed]
	car.scale_wheels(effects[UpgradeItemDefinition.StatType.WheelSize])
	car.set_bounciness(effects[UpgradeItemDefinition.StatType.Bounciness])
	car.apply_downward_pressure(BASE_DOWNWARD_PRESSURE * effects[UpgradeItemDefinition.StatType.DownwardPressure])
