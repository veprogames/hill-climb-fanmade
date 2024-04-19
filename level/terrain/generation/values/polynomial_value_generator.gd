class_name PolynomialValueGenerator
extends BaseValueGenerator

@export var base: float
@export var delta: float
@export var exponent: float = 1.0
@export var min_value: float
@export var max_value: float = INF

func get_value(meters: float) -> float:
	var amplitude: float = base + delta * absf(meters) ** exponent
	return clampf(amplitude, min_value, max_value)
