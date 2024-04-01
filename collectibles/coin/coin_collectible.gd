class_name CoinCollectible
extends BaseCollectible

@export var value: int = 0

@onready var label_value: Label = $Sprite2D/LabelValue

func _ready() -> void:
	super._ready()
	
	label_value.text = "%d" % value

func _on_collected(_by: Car) -> void:
	Game.save.coins += value
