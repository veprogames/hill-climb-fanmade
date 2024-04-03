class_name PauseModal
extends BaseModal


func _on_opened() -> void:
	get_tree().paused = true


func _on_closed() -> void:
	get_tree().paused = false


func _on_button_continue_pressed() -> void:
	close()


func _on_button_main_menu_pressed() -> void:
	close()
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
