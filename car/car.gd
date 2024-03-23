class_name Car
extends RigidBody2D

signal died

const SPEED: float = 180_000.0

var touch_gas: bool = false
var touch_brake: bool = false

@onready var wheel_l: RigidBody2D = $PinJoint2D/WheelL
@onready var wheel_r: RigidBody2D = $PinJoint2D2/WheelR

@onready var viewport_rect: Rect2 = get_viewport_rect()

@onready var timer_death: Timer = $TimerDeath

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

func _physics_process(_delta: float) -> void:
	if not is_dead():
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

func is_dead() -> bool:
	return !timer_death.is_stopped()

func _on_head_body_entered(body: Node) -> void:
	if body is SimpleTerrain:
		if timer_death.is_stopped():
			died.emit()
			
			timer_death.start()
			
			break_neck()
			await timer_death.timeout
			get_tree().reload_current_scene.call_deferred()
