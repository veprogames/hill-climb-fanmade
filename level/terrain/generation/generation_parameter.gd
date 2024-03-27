class_name GenerationParameter
extends Resource

@export var height_values: BaseValueGenerator
@export var amplitude_values: BaseValueGenerator

func get_y(meters: float) -> float:
	var amplitude: float = amplitude_values.get_value(meters)
	return height_values.get_value(meters) * amplitude
