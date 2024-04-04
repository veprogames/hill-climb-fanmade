class_name SaveGameGarage
extends Resource

const MAX_EQUIPS: int = 10

signal item_added(item: UpgradeItem)

@export var inventory: Array[UpgradeItem] = []

var definition_engine: UpgradeItemDefinition = preload("res://item/upgrade/definitions/engine_acceleration.tres")

func initialize() -> void:
	var free_engine: UpgradeItem = UpgradeItem.new(definition_engine)
	add_item(free_engine)

func add_item(item: UpgradeItem) -> void:
	inventory.append(item)
	item_added.emit(item)

func get_equipped_items() -> Array[UpgradeItem]:
	return inventory.filter(func(item: UpgradeItem) -> bool:
		return item.is_equipped
	)

func get_equipped_count() -> int:
	return get_equipped_items().size()

func get_item_count() -> int:
	return inventory.size()

func get_all_effects() -> CarStats:
	var result: Dictionary = {
		UpgradeItemDefinition.StatType.EngineAcceleration: 1.0,
		UpgradeItemDefinition.StatType.WheelSize: 1.0,
		UpgradeItemDefinition.StatType.FuelCapacity: 30.0,
		UpgradeItemDefinition.StatType.Bounciness: 1.0,
		UpgradeItemDefinition.StatType.DownwardPressure: 0.0,
		UpgradeItemDefinition.StatType.AirRotationSpeed: 1.0,
	}
	
	var equipped: Array[UpgradeItem] = get_equipped_items()
	
	for item: UpgradeItem in equipped:
		var type: UpgradeItemDefinition.StatType = item.definition.stat
		var operation: UpgradeItemDefinition.StatOperationType = item.definition.operation
		
		if !(type in result):
			continue
		
		var effect: float = item.get_current_effect()
		
		match operation:
			UpgradeItemDefinition.StatOperationType.Addition:
				result[type] += effect
			UpgradeItemDefinition.StatOperationType.Substraction:
				result[type] -= effect
			UpgradeItemDefinition.StatOperationType.Multiplication:
				result[type] *= effect
			UpgradeItemDefinition.StatOperationType.Division:
				result[type] /= effect
	
	var stats: CarStats = CarStats.new()
	stats._raw_engine_acceleration = result[UpgradeItemDefinition.StatType.EngineAcceleration]
	stats._raw_air_rotation_speed = result[UpgradeItemDefinition.StatType.AirRotationSpeed]
	stats.wheel_size = result[UpgradeItemDefinition.StatType.WheelSize]
	stats.fuel_capacity = result[UpgradeItemDefinition.StatType.FuelCapacity]
	stats._raw_downward_pressure = result[UpgradeItemDefinition.StatType.DownwardPressure]
	stats.bounciness = result[UpgradeItemDefinition.StatType.Bounciness]
	
	return stats
