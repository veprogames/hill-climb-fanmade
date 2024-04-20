class_name ExperienceBar
extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var label_xp: Label = $LabelXP
@onready var label_level: Label = $LabelLevel
@onready var label_title: Label = $LabelTitle

@onready var experience: ExperienceManager = Game.save.experience

func _ready() -> void:
	update_ui()
	
	experience.level_changed.connect(_on_experience_level_changed)
	experience.xp_changed.connect(_on_experience_xp_changed)

func update_ui() -> void:
	label_level.text = "%d" % (experience.current_level + 1)
	label_title.text = experience.get_current_title()
	label_xp.text = F.F(experience.get_xp_on_current_level())
	progress_bar.value = experience.get_percentage_to_next_level()


func _on_experience_level_changed(_level: int) -> void:
	update_ui()
	
func _on_experience_xp_changed(_xp: int) -> void:
	update_ui()
