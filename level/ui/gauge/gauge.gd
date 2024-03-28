class_name Gauge
extends TextureRect

const ROTATION_1: float = 265.0

@export var value: float : set = _set_value
@export var text: String : set = _set_text

@onready var meter: TextureRect = $Meter
@onready var label_text: Label = $LabelText
@onready var text_background: ColorRect = $TextBackground

func _set_value(new_value: float) -> void:
	value = new_value
	
	if not is_node_ready():
		await ready
	
	meter.rotation_degrees = value * ROTATION_1

func _set_text(new_text: String) -> void:
	text = new_text
	
	if not is_node_ready():
		await ready
	
	text_background.visible = !new_text.is_empty()
	label_text.text = new_text
