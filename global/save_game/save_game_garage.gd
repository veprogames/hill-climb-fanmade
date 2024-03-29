class_name SaveGameGarage
extends Resource

signal item_added(item: UpgradeItem)

@export var inventory: Array[UpgradeItem] = []

func add_item(item: UpgradeItem) -> void:
	inventory.append(item)
	item_added.emit(item)

func get_equipped_items() -> Array[UpgradeItem]:
	return inventory.filter(func(item: UpgradeItem) -> bool:
		return item.is_equipped
	)

func get_all_effects() -> Dictionary:
	var result: Dictionary = {
		UpgradeItemDefinition.StatType.EngineAcceleration: 1.0,
		UpgradeItemDefinition.StatType.WheelSize: 1.0,
		UpgradeItemDefinition.StatType.FuelCapacity: 30.0,
		UpgradeItemDefinition.StatType.Bounciness: 16.0,
		UpgradeItemDefinition.StatType.DownwardPressure: 0.0,
		UpgradeItemDefinition.StatType.AirRoationSpeed: 1.0,
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
	
	return result
