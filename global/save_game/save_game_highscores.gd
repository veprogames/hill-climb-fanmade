class_name SaveGameHighscores
extends Resource

@export var highscores: Dictionary = {}

func try_submit(data: LevelData, meters: float) -> void:
	var id: String = data.id
	if id not in highscores:
		highscores[id] = meters
	else:
		@warning_ignore("unsafe_cast") # Dictionaries can't be typed as of Godot 4.2
		var current_highscore: float = highscores[id] as float
		highscores[id] = maxf(current_highscore, meters)

func get_highscore(data: LevelData) -> float:
	var id: String = data.id
	if id not in highscores:
		return 0.0
	@warning_ignore("unsafe_cast") # Dictionaries can't be typed as of Godot 4.2
	return highscores[id] as float
