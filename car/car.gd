class_name Car
extends RigidBody2D

const SPEED := 180_000.0

@onready var wheel_l: RigidBody2D = $PinJoint2D/WheelL
@onready var wheel_r: RigidBody2D = $PinJoint2D2/WheelR

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		wheel_l.apply_torque(-SPEED)
		wheel_r.apply_torque(-SPEED)
		#wheel_l.angular_velocity = -SPEED
		#wheel_r.angular_velocity = -SPEED
		apply_torque(SPEED)
	elif Input.is_action_pressed("ui_right"):
		wheel_l.apply_torque(SPEED)
		wheel_r.apply_torque(SPEED)
		apply_torque(-SPEED)
