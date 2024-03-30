class_name MainMenu
extends Node2D

func _on_button_quit_pressed() -> void:
	Game.save_game()
	get_tree().quit()


func _on_button_garage_pressed() -> void:
	get_tree().change_scene_to_file("res://garage/garage.tscn")


func _on_button_shop_pressed() -> void:
	get_tree().change_scene_to_file("res://shop/shop.tscn")
