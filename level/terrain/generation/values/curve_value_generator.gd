class_name CurveValueGenerator
extends BaseValueGenerator

@export var segments: Array[Curve]
@export var segment_length: float = 100.0
@export var generation_seed: int = 0

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var segment_indices: Array[int] = []

func _init() -> void:
	rng.seed = generation_seed

func get_value(meters: float) -> float:
	var pos: float = fmod(meters / segment_length, 1.0)
	var nth_segment: int = int(meters / segment_length)
	var segment_index: int = get_segment_index_at(nth_segment)
	
	var sampled: float = segments[segment_index].sample(pos)
	# make it so that 0.5 is the middle
	sampled -= 0.5
	return -sampled

func get_segment_index_at(nth_segment: int) -> int:
	if segment_indices.size() <= nth_segment:
		_generate_indices_to(nth_segment)
	return segment_indices[nth_segment]

func _generate_indices_to(n: int) -> void:
	while segment_indices.size() <= n:
		segment_indices.append(rng.randi() % segments.size())
