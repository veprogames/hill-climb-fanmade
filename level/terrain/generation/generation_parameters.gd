class_name GenerationParameters
extends Resource

@export var noises: Array[GenerationParameter]

func get_y(for_x: float) -> float:
	var meters: float = for_x / Level.PX_TO_M
	return noises \
		.map(func(param: GenerationParameter) -> float:
			return param.get_y(meters)) \
		.reduce(func(a: float, b: float) -> float:
			return a + b)
