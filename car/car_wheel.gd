class_name CarWheel
extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var wheel_scale: float = 1.0 : set = _set_wheel_scale

var on_ground: bool = false

func _set_wheel_scale(scale_: float) -> void:
	wheel_scale = scale_
	sprite_2d.scale = Vector2.ONE * scale_
	collision_shape_2d.scale = Vector2.ONE * scale_

func set_bounciness(bounciness: float) -> void:
	physics_material_override.bounce = bounciness


func _on_body_entered(body: Node) -> void:
	if body is SimpleTerrain:
		on_ground = true


func _on_body_exited(body: Node) -> void:
	if body is SimpleTerrain:
		on_ground = false
