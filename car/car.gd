class_name Car
extends RigidBody2D

signal died
signal level_ended
signal fuel_depleted
signal low_fuel_reached
signal refueled(was_out_of: bool)

signal gas_changed(new_state: bool)
signal brake_changed(new_state: bool)

var MainMenuScene: PackedScene = preload("res://main_menu/main_menu.tscn")

var touch_gas: bool = false : set = _set_touch_gas
var touch_brake: bool = false : set = _set_touch_brake

var fuel: float = 1.0

var on_low_fuel: bool = false
var out_of_fuel: bool = false

var highest_x: float = 0.0

var stats: CarStats = CarStats.new()

@onready var pin_joint_l: PinJoint2D = $PinJointL
@onready var pin_joint_r: PinJoint2D = $PinJointR

@onready var wheel_l: CarWheel = $PinJointL/WheelL
@onready var wheel_r: CarWheel = $PinJointR/WheelR

@onready var viewport_rect: Rect2 = get_viewport_rect()

@onready var timer_respawn: Timer = $TimerRespawn

@onready var pin_joint_2d_neck: PinJoint2D = $Head/PinJoint2DNeck

@onready var audio_stream_player_neck_break: AudioStreamPlayer = $AudioStreamPlayerNeckBreak

func _ready() -> void:
	var garage: SaveGameGarage = Game.save.garage
	highest_x = position.x
	stats = garage.get_all_effects()
	apply_car_stats()

func _set_touch_brake(brake: bool) -> void:
	touch_brake = brake
	brake_changed.emit(brake)

func _set_touch_gas(gas: bool) -> void:
	touch_gas = gas
	gas_changed.emit(gas)

func _unhandled_input(event: InputEvent) -> void:
	var touch_event: InputEventScreenTouch = event as InputEventScreenTouch
	if touch_event != null:
		var x_half: float = viewport_rect.position.x + viewport_rect.size.x / 2.0
		var is_right: bool = touch_event.position.x > x_half
		
		if is_right:
			touch_gas = touch_event.pressed
		else:
			touch_brake = touch_event.pressed

func _process(delta: float) -> void:
	fuel -= delta / stats.fuel_capacity
	
	if !on_low_fuel and fuel < 0.2:
		on_low_fuel = true
		low_fuel_reached.emit()
	
	if !out_of_fuel and fuel <= 0.0:
		out_of_fuel = true
		fuel_depleted.emit()
		respawn()
	
	highest_x = maxf(highest_x, position.x)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_brake"):
		touch_brake = true
	elif Input.is_action_just_released("player_brake"):
		touch_brake = false
	
	if Input.is_action_just_pressed("player_gas"):
		touch_gas = true
	elif Input.is_action_just_released("player_gas"):
		touch_gas = false
	
	if can_drive():
		var engine_acceleration: float = stats.engine_acceleration
		var air_rotation_speed: float = stats.air_rotation_speed
		
		if touch_brake:
			wheel_l.apply_torque(-engine_acceleration)
			wheel_r.apply_torque(-engine_acceleration)
			if !is_on_ground():
				apply_torque(air_rotation_speed)
		elif touch_gas:
			wheel_l.apply_torque(engine_acceleration)
			wheel_r.apply_torque(engine_acceleration)
			if !is_on_ground():
				apply_torque(-air_rotation_speed)
	
	apply_central_force(stats.downward_pressure)
	apply_central_force(stats.rightward_pressure)

func is_on_ground() -> bool:
	return true in [wheel_l.on_ground, wheel_r.on_ground]

func get_meters_per_second() -> float:
	return absf(linear_velocity.x / Level.PX_TO_M)

func scale_wheels(to_scale: float) -> void:
	wheel_l.wheel_scale = to_scale
	wheel_r.wheel_scale = to_scale

func set_joint_softness(joint_softness: float) -> void:
	pin_joint_l.softness = joint_softness
	pin_joint_r.softness = joint_softness

func set_joint_bias(bias: float) -> void:
	pin_joint_l.bias = bias
	pin_joint_r.bias = bias

func apply_car_stats() -> void:
	angular_damp = stats.stability
	scale_wheels(stats.wheel_size)
	set_joint_softness(stats.get_joint_softness())
	set_joint_bias(stats.get_joint_bias())
	for wheel: CarWheel in [wheel_l, wheel_r]:
		wheel.set_bounciness(stats.bounciness)

func break_neck() -> void:
	pin_joint_2d_neck.node_a = ""
	pin_joint_2d_neck.node_b = ""
	audio_stream_player_neck_break.play()

func is_neck_broken() -> bool:
	return pin_joint_2d_neck.node_a.is_empty() and pin_joint_2d_neck.node_b.is_empty()

func is_game_over() -> bool:
	return !timer_respawn.is_stopped()

func can_drive() -> bool:
	return !is_game_over()

func refuel() -> void:
	fuel = 1.0
	if !timer_respawn.is_stopped() and !is_neck_broken():
		timer_respawn.stop()
		refueled.emit(true)
	else:
		refueled.emit(false)

func respawn() -> void:
	timer_respawn.start()

func _on_head_body_entered(body: Node) -> void:
	if body is SimpleTerrain:
		if not is_neck_broken():
			died.emit()
			break_neck()
		if timer_respawn.is_stopped():
			respawn()


func _on_timer_respawn_timeout() -> void:
	level_ended.emit()
	get_tree().change_scene_to_packed(MainMenuScene)


func _on_refueled(_was_out_of: bool) -> void:
	on_low_fuel = false
	out_of_fuel = false
