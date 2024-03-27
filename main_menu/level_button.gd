class_name LevelButton
extends TextureRect

@export_file("*.tscn") var scene_path: String
@export var title: String
@export var thumbnail: Texture

@onready var label_title: Label = $LabelTitle

func _ready() -> void:
	texture = thumbnail
	label_title.text = title


func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file(scene_path)
