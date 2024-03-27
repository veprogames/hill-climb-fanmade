class_name SineValueGenerator
extends BaseValueGenerator

@export var period: float
@export var min_value: float = -1.0
@export var max_value: float = 1.0

func _ready() -> void:
	super._ready()
	assert(period > 0.0)

func get_value(meters: float) -> float:
	var x: float = TAU * meters / period
	var sine: float = sin(x)
	return clampf(sine, min_value, max_value)
