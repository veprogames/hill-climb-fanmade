class_name Credits
extends Node2D


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	var string: String = meta as String
	if string != null and string.begins_with("https://"):
		OS.shell_open(string)


func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
