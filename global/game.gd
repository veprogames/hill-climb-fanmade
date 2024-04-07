class_name Game
extends Node

const SAVE_PATH: String = "user://hill_climb_savegame.tres"

static var save: SaveGame = SaveGame.new()

static func save_game() -> void:
	ResourceSaver.save(Game.save, SAVE_PATH)

static func try_load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var loaded: SaveGame = SafeResourceLoader.load(SAVE_PATH) as SaveGame
		
		if loaded != null:
			Game.save.coins = loaded.coins
			Game.save.gems = loaded.gems
			Game.save.garage.inventory = loaded.garage.inventory
			Game.save.shop.item_offers = loaded.shop.item_offers
			Game.save.highscores = loaded.highscores
