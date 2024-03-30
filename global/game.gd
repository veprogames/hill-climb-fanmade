class_name GameNode
extends Node

const SAVE_PATH: String = "user://hill_climb_savegame.tres"

var save: SaveGame = SaveGame.new()

func _ready() -> void:
	save.initialize()
	
	try_load_game()

func save_game() -> void:
	ResourceSaver.save(save, SAVE_PATH)

func try_load_game() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var loaded: SaveGame = SafeResourceLoader.load(SAVE_PATH) as SaveGame
		
		if loaded != null:
			save = loaded
