class_name SaveGame
extends Resource

signal coins_changed(to: int)
signal gems_changed(to: int)

@export var coins: int = 0 : set = _set_coins
@export var gems: int = 0 : set = _set_gems

@export var garage: SaveGameGarage = SaveGameGarage.new()

func test_add_item() -> void:
	var item: UpgradeItem = UpgradeItem.new()
	item.definition = load("res://item/upgrade/definitions/engine_acceleration.tres")
	item.equipped = false
	item.level = 10
	garage.add_item(item)

func _set_coins(to: int) -> void:
	coins = to
	coins_changed.emit(to)

func _set_gems(to: int) -> void:
	gems = to
	gems_changed.emit(to)
