extends Node

var save: SaveGame = SaveGame.new()

func _ready() -> void:
	save.test_add_item()
