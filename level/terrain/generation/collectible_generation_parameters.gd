class_name CollectibleGenerationParameters
extends Resource

@export_category("Fuel")
@export var fuel_distance_base: float = 90.0
@export var fuel_distance_delta: float = 0.0
@export var fuel_distance_exponent: float = 1.0
@export var fuel_distance_snap: float = 30.0

@export_category("Coins")
@export var coin_distance: float = 30.0
@export var coin_distance_offset: float = 5.0
@export var coin_formation_value_base: int = 1
@export var coin_formation_value_delta: int = 0

@export_category("Gems")
@export var gem_distance: float = 100.0
@export var gem_distance_offset: float = 10.0

func get_fuel_position_in_meters(nth_fuel: int) -> float:
	var position: float = fuel_distance_base * nth_fuel + fuel_distance_delta * nth_fuel ** fuel_distance_exponent
	position = snappedf(position, fuel_distance_snap)
	return position

func get_coin_position_in_meters(nth_coins: int) -> float:
	return coin_distance_offset + coin_distance * nth_coins

func get_coins_value(nth_coins: int) -> int:
	return coin_formation_value_base + coin_formation_value_delta * nth_coins

func get_gem_position_in_meters(nth_gem: int) -> float:
	return gem_distance_offset + gem_distance * nth_gem
