class_name CarStats
extends RefCounted

const BASE_ACCELERATION: float = 100_000.0
const BASE_AIR_ROTATION_SPEED: float = 200_000.0
const BASE_PRESSURE: float = 1_000.0
const BASE_STABILITY: float = 1.5

var _raw_engine_acceleration: float = 1.0 : set = _set_raw_engine_acceleration
var _raw_air_rotation_speed: float = 1.0 : set = _set_raw_air_rotation_speed
var _raw_downward_pressure: float = 1.0 : set = _set_raw_downward_pressure
var _raw_rightward_pressure: float = 1.0 : set = _set_raw_rightward_pressure
var _raw_stability: float = 1.0 : set = _set_raw_stability

var engine_acceleration: float = BASE_ACCELERATION
var air_rotation_speed: float = BASE_AIR_ROTATION_SPEED
var fuel_capacity: float = 30.0
var downward_pressure: Vector2 = Vector2.ZERO
var rightward_pressure: Vector2 = Vector2.ZERO
var bounciness: float = 1.0
var wheel_size: float = 1.0
var stability: float = 1.0
var camera_zoom: float = 1.0

func _set_raw_engine_acceleration(acceleration: float) -> void:
	_raw_engine_acceleration = acceleration
	engine_acceleration = acceleration * BASE_ACCELERATION

func _set_raw_air_rotation_speed(speed: float) -> void:
	_raw_air_rotation_speed = speed
	air_rotation_speed = speed * BASE_AIR_ROTATION_SPEED

func _set_raw_downward_pressure(pressure: float) -> void:
	_raw_downward_pressure = pressure
	downward_pressure = pressure * BASE_PRESSURE * Vector2.DOWN

func _set_raw_rightward_pressure(pressure: float) -> void:
	_raw_rightward_pressure = pressure
	rightward_pressure = pressure * BASE_PRESSURE * Vector2.RIGHT

func _set_raw_stability(stability_: float) -> void:
	_raw_stability = stability_
	stability = _raw_stability * BASE_STABILITY

func get_joint_softness() -> float:
	return 2.0 + (bounciness ** 0.5) * 14.0

func get_joint_bias() -> float:
	return bounciness * 0.3
