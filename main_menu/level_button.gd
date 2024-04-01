class_name LevelButton
extends TextureButton

@export var level_data: LevelData

@onready var label_title: Label = $LabelTitle
@onready var label_highscore: Label = $HBoxContainerHighscore/LabelHighscore

func _ready() -> void:
	assert(level_data != null)
	
	var highscore: float = Game.save.highscores.get_highscore(level_data)
	
	texture_normal = level_data.thumbnail
	label_title.text = level_data.title
	label_highscore.text = "%s m" % F.F(highscore)

func _on_pressed() -> void:
	get_tree().change_scene_to_file(level_data.scene_path)
