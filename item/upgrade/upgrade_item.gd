class_name UpgradeItem
extends BaseItem

signal level_changed(to: int)
signal tuned_level_changed(to: int)
signal equipped_changed(to: bool)
signal equipped
signal unequipped
signal upgraded

@export var level: int = 0 : set = _set_level
@export var tuned_level: int = -1 : set = _set_tuned_level
@export var is_equipped: bool = false : set = _set_is_equipped
@export var definition: UpgradeItemDefinition = null

func _init(definition_: UpgradeItemDefinition = null, level_: int = 0) -> void:
	definition = definition_
	level = level_

func _set_level(lvl: int) -> void:
	level = lvl
	level_changed.emit(lvl)

func _set_tuned_level(lvl: int) -> void:
	tuned_level = lvl
	tuned_level_changed.emit(lvl)

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
	if is_tuned():
		return definition.get_effect(tuned_level)
	return definition.get_effect(level)

func can_afford() -> bool:
	return Game.save.coins >= get_current_price()

func can_equip() -> bool:
	return Game.save.garage.get_equipped_count() < Game.save.garage.get_max_equips()

func try_equip() -> void:
	if can_equip():
		is_equipped = true

func is_tuned() -> bool:
	return tuned_level >= 0 and tuned_level < level

func is_maxed() -> bool:
	return level >= definition.max_level

func try_upgrade() -> void:
	if can_afford() and !is_maxed():
		Game.save.coins -= get_current_price()
		if !is_tuned():
			tuned_level = -1
		level += 1
		Game.save.experience.xp += 100
		upgraded.emit()
