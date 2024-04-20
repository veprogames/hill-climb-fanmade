class_name SaveGame
extends Resource

signal coins_changed(to: int)
signal gems_changed(to: int)

@export var coins: int = 0 : set = _set_coins
@export var gems: int = 0 : set = _set_gems

@export var garage: SaveGameGarage = SaveGameGarage.new()
@export var shop: SaveGameShop = SaveGameShop.new()
@export var highscores: SaveGameHighscores = SaveGameHighscores.new()
@export var experience: SaveGameExperience = SaveGameExperience.new()

func initialize() -> void:
	shop.initialize()
	garage.initialize()

func _set_coins(to: int) -> void:
	coins = to
	coins_changed.emit(to)

func _set_gems(to: int) -> void:
	gems = to
	gems_changed.emit(to)
