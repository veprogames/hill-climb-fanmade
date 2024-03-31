class_name LevelButton
extends TextureRect

@export var level_data: LevelData

@onready var label_title: Label = $LabelTitle

func _ready() -> void:
	assert(level_data != null)
	
	texture = level_data.thumbnail
	label_title.text = level_data.title


func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file(level_data.scene_path)
