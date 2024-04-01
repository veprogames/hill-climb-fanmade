class_name CarEngineSoundPlayer
extends AudioStreamPlayer

@export var car: Car

func _ready() -> void:
	assert(car != null)
	
	car.fuel_depleted.connect(_on_car_fuel_depleted)
	car.refueled.connect(_on_car_refueled)

func _process(delta: float) -> void:
	var gas: bool = car.touch_gas
	var brake: bool = car.touch_brake
	
	var target_pitch: float = 1.0
	
	if car.is_game_over():
		target_pitch = 1.0
	elif gas:
		target_pitch = 1.75
	elif brake:
		target_pitch = 1.4
	
	var speed_multiplier: float = remap(
		car.get_meters_per_second(),
		5, 50,
		1.0, 2.5
	)
	
	speed_multiplier = maxf(speed_multiplier, 1.0)
	
	target_pitch *= speed_multiplier
	
	pitch_scale = lerpf(pitch_scale, target_pitch, delta * 2.5)


func _on_car_fuel_depleted() -> void:
	stop()


func _on_car_refueled(was_out_of: bool) -> void:
	if was_out_of:
		play()
