extends Node

func _on_timer_save_timeout() -> void:
	Game.save_game()
