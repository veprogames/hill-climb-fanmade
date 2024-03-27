class_name NoiseValueGenerator
extends BaseValueGenerator

@export var noise: FastNoiseLite

func get_value(meters: float) -> float:
	return noise.get_noise_1d(meters)
