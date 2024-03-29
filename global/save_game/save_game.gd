class_name SaveGame
extends Resource

signal coins_changed(to: int)
signal gems_changed(to: int)

@export var coins: int = 0 : set = _set_coins
@export var gems: int = 0 : set = _set_gems

@export var garage: SaveGameGarage = SaveGameGarage.new()
@export var shop: SaveGameShop = SaveGameShop.new()

var definition: UpgradeItemDefinition = preload("res://item/upgrade/definitions/engine_acceleration.tres")

func test_add_item() -> void:
	var item: UpgradeItem = UpgradeItem.new(definition, 10)
	var item2: UpgradeItem = UpgradeItem.new(definition)
	
	garage.add_item(item)
	garage.add_item(item2)

func _set_coins(to: int) -> void:
	coins = to
	coins_changed.emit(to)

func _set_gems(to: int) -> void:
	gems = to
	gems_changed.emit(to)
