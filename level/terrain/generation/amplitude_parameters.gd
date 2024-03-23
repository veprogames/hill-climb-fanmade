class_name AmplitudeParameters
extends Resource

@export var base: float
@export var delta_per_meter: float
@export var min_amplitude: float
@export var max_amplitude: float = INF

func get_amplitude(meters: float) -> float:
	var amplitude: float = base + delta_per_meter * meters
	return clampf(amplitude, min_amplitude, max_amplitude)
