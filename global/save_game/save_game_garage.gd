class_name SaveGameGarage
extends Resource

signal item_added(item: UpgradeItem)

@export var inventory: Array[UpgradeItem] = []

func add_item(item: UpgradeItem) -> void:
	inventory.append(item)
	item_added.emit(item)

func get_equipped_items() -> Array[UpgradeItem]:
	return inventory.filter(func(item: UpgradeItem) -> bool:
		return item.equipped
	)

func get_all_effects() -> Dictionary:
	var result: Dictionary = {
		UpgradeItemDefinition.StatType.EngineAcceleration: 1.0 
	}
	
	var equipped: Array[UpgradeItem] = get_equipped_items()
	
	for item: UpgradeItem in equipped:
		var type: UpgradeItemDefinition.StatType = item.definition.stat
		var operation: UpgradeItemDefinition.StatOperationType = item.definition.operation
		
		if !(type in result):
			continue
		
		match operation:
			UpgradeItemDefinition.StatOperationType.Addition:
				result[type] += item.get_current_effect()
	
	return result
