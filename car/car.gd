class_name Car
extends RigidBody2D

signal died
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

@onready var car_stats_applier: CarStatsApplier = $CarStatsApplier

@onready var pin_joint_l: PinJoint2D = $PinJointL
@onready var pin_joint_r: PinJoint2D = $PinJointR

@onready var wheel_l: CarWheel = $PinJointL/WheelL
@onready var wheel_r: CarWheel = $PinJointR/WheelR

@onready var viewport_rect: Rect2 = get_viewport_rect()

@onready var timer_respawn: Timer = $TimerRespawn

@onready var pin_joint_2d_neck: PinJoint2D = $Head/PinJoint2DNeck

func _set_touch_brake(brake: bool) -> void:
	touch_brake = brake
	brake_changed.emit(brake)

func _set_touch_gas(gas: bool) -> void:
	touch_gas = gas
	gas_changed.emit(gas)

func _input(event: InputEvent) -> void:
	var touch_event: InputEventScreenTouch = event as InputEventScreenTouch
	if touch_event != null:
		var x_half: float = viewport_rect.position.x + viewport_rect.size.x / 2.0
		var is_right: bool = touch_event.position.x > x_half
		
		if is_right:
			touch_gas = touch_event.pressed
		else:
			touch_brake = touch_event.pressed

func _process(delta: float) -> void:
	fuel -= delta / car_stats_applier.fuel_capacity
	
	if !on_low_fuel and fuel < 0.2:
		on_low_fuel = true
		low_fuel_reached.emit()
	
	if is_out_of_fuel() and not is_game_over():
		fuel_depleted.emit()
		respawn()

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
		var engine_acceleration: float = car_stats_applier.engine_acceleration
		var air_rotation_speed: float = car_stats_applier.air_rotation_speed
		
		if touch_brake:
			wheel_l.apply_torque(-engine_acceleration)
			wheel_r.apply_torque(-engine_acceleration)
			apply_torque(air_rotation_speed)
		elif touch_gas:
			wheel_l.apply_torque(engine_acceleration)
			wheel_r.apply_torque(engine_acceleration)
			apply_torque(-air_rotation_speed)

func scale_wheels(to_scale: float) -> void:
	wheel_l.wheel_scale = to_scale
	wheel_r.wheel_scale = to_scale

func set_bounciness(joint_softness: float) -> void:
	pin_joint_l.softness = joint_softness
	pin_joint_r.softness = joint_softness

func apply_downward_pressure(strength: float) -> void:
	add_constant_force(Vector2.DOWN * strength)

func break_neck() -> void:
	pin_joint_2d_neck.node_a = ""
	pin_joint_2d_neck.node_b = ""

func is_neck_broken() -> bool:
	return pin_joint_2d_neck.node_a.is_empty() and pin_joint_2d_neck.node_b.is_empty()

func is_game_over() -> bool:
	return !timer_respawn.is_stopped()

func is_out_of_fuel() -> bool:
	return fuel <= 0

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
		if timer_respawn.is_stopped():
			died.emit()
			break_neck()
			
			respawn()


func _on_timer_respawn_timeout() -> void:
	get_tree().change_scene_to_packed(MainMenuScene)


func _on_refueled(_was_out_of: bool) -> void:
	on_low_fuel = false
