extends Node

func _ready() -> void:
	Game.save.initialize()
	
	Game.try_load_game()

func _on_timer_save_timeout() -> void:
	Game.save_game()
