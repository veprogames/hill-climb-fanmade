class_name CollectibleGenerationParameters
extends Resource

@export_category("Fuel")
@export var fuel_distance_base: float = 90.0
@export var fuel_distance_delta: float = 0.0
@export var fuel_distance_exponent: float = 1.0
@export var fuel_distance_snap: float = 30.0

func get_fuel_position_in_meters(nth_fuel: int) -> float:
	var position: float = fuel_distance_base * nth_fuel + fuel_distance_delta * nth_fuel ** fuel_distance_exponent
	position = snappedf(position, fuel_distance_snap)
	return position
