class_name GenerationBorder
extends Area2D

signal car_entered

func _on_body_entered(body: Node2D) -> void:
	if body is Car:
		car_entered.emit()
