class_name CurrencyDisplayGems
extends HBoxContainer

@onready var label_value: Label = $LabelValue

func _ready() -> void:
	label_value.text = F.F(Game.save.gems)
	
	Game.save.gems_changed.connect(_on_save_gems_changed)

func _on_save_gems_changed(to: int) -> void:
	label_value.text = F.F(to)
