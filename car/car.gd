class_name Car
extends RigidBody2D

signal died
signal fuel_depleted
signal refueled(was_out_of: bool)

const SPEED: float = 180_000.0

var touch_gas: bool = false
var touch_brake: bool = false

var fuel: float = 1.0
var fuel_capacity: float = 30.0

@onready var wheel_l: RigidBody2D = $PinJoint2D/WheelL
@onready var wheel_r: RigidBody2D = $PinJoint2D2/WheelR

@onready var viewport_rect: Rect2 = get_viewport_rect()

@onready var timer_respawn: Timer = $TimerRespawn

@onready var pin_joint_2d_neck: PinJoint2D = $Head/PinJoint2DNeck

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
	fuel -= delta / fuel_capacity
	
	if is_out_of_fuel() and not is_game_over():
		fuel_depleted.emit()
		respawn()

func _physics_process(_delta: float) -> void:
	if can_drive():
		if Input.is_action_pressed("player_brake") or touch_brake:
			wheel_l.apply_torque(-SPEED)
			wheel_r.apply_torque(-SPEED)
			apply_torque(SPEED)
		elif Input.is_action_pressed("player_gas") or touch_gas:
			wheel_l.apply_torque(SPEED)
			wheel_r.apply_torque(SPEED)
			apply_torque(-SPEED)

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
	get_tree().reload_current_scene.call_deferred()
