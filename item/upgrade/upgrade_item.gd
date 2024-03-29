class_name UpgradeItem
extends BaseItem

signal level_changed(to: int)
signal equipped_changed(to: bool)
signal equipped
signal unequipped

@export var level: int = 0 : set = _set_level
@export var is_equipped: bool = false : set = _set_is_equipped
@export var definition: UpgradeItemDefinition

func _set_level(lvl: int) -> void:
	level = lvl
	level_changed.emit(lvl)

func _set_is_equipped(equip: bool) -> void:
	is_equipped = equip
	equipped_changed.emit(equip)
	if equip:
		equipped.emit()
	else:
		unequipped.emit()

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
