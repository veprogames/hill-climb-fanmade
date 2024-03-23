class_name GenerationParameter
extends Resource

@export var noise: FastNoiseLite
@export var amplitude_parameters: AmplitudeParameters

func get_y(meters: float) -> float:
	var amplitude: float = amplitude_parameters.get_amplitude(meters)
	return noise.get_noise_1d(meters) * amplitude
