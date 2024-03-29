class_name CarStatsApplier
extends Node2D

const BASE_ACCELERATION: float = 80_000.0
const BASE_AIR_ACCELERATION: float = 150_000.0

var garage: SaveGameGarage

var engine_acceleration: float = 0.0

func _ready() -> void:
	garage = Game.save.garage
	apply_stats()

func apply_stats() -> void:
	var effects: Dictionary = garage.get_all_effects()
	
	engine_acceleration = BASE_ACCELERATION * effects[UpgradeItemDefinition.StatType.EngineAcceleration]
