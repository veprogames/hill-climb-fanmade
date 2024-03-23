class_name Car
extends RigidBody2D

const SPEED: float = 180_000.0

var touch_gas: bool = false
var touch_brake: bool = false

@onready var wheel_l: RigidBody2D = $PinJoint2D/WheelL
@onready var wheel_r: RigidBody2D = $PinJoint2D2/WheelR

@onready var viewport_rect: Rect2 = get_viewport_rect()

func _input(event: InputEvent) -> void:
	var touch_event: InputEventScreenTouch = event as InputEventScreenTouch
	if touch_event != null:
		var x_half: float = viewport_rect.position.x + viewport_rect.size.x / 2.0
		var is_right: bool = touch_event.position.x > x_half
		
		if is_right:
			touch_gas = touch_event.pressed
		else:
			touch_brake = touch_event.pressed

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("player_brake") or touch_brake:
		wheel_l.apply_torque(-SPEED)
		wheel_r.apply_torque(-SPEED)
		apply_torque(SPEED)
	elif Input.is_action_pressed("player_gas") or touch_gas:
		wheel_l.apply_torque(SPEED)
		wheel_r.apply_torque(SPEED)
		apply_torque(-SPEED)
