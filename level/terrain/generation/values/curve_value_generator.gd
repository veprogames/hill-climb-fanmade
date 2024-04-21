class_name CurveValueGenerator
extends BaseValueGenerator

@export var segments: Array[Curve]
@export var segment_length: float = 100.0
@export var generation_seed: int = 0

func get_value(meters: float) -> float:
	var pos: float = fmod(meters / segment_length, 1.0)
	var nth_segment: int = int(meters / segment_length)
	var segment_index: int = (nth_segment * generation_seed + generation_seed) % segments.size()
	return -segments[segment_index].sample(pos)
