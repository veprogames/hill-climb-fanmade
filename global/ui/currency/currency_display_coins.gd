class_name CurrencyDisplayCoins
extends HBoxContainer

@onready var label_value: Label = $LabelValue

func _ready() -> void:
	label_value.text = F.F(Game.save.coins)
	
	Game.save.coins_changed.connect(_on_save_coins_changed)

func _on_save_coins_changed(to: int) -> void:
	label_value.text = F.F(to)
