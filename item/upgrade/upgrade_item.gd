class_name UpgradeItem
extends BaseItem

@export var level: int = 0
@export var equipped: bool = false
@export var definition: UpgradeItemDefinition

func get_current_price() -> int:
	return definition.get_price(level)

func get_current_effect() -> float:
	return definition.get_effect(level)

func can_afford() -> bool:
	return Game.save.coins >= get_current_price()

func is_maxed() -> bool:
	return level >= definition.max_level

func try_upgrade() -> void:
	if can_afford() and !is_maxed():
		Game.save.coins -= get_current_price()
		level += 1
