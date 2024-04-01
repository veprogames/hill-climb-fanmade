class_name Level
extends Node2D

@export var data: LevelData
@onready var car: Car = $Car

static var PX_TO_M: float = 100.0

func _ready() -> void:
	assert(data != null)


func _on_car_level_ended() -> void:
	var player_meters: float = car.highest_x / Level.PX_TO_M
	Game.save.highscores.try_submit(data, player_meters)
	Game.save_game()
