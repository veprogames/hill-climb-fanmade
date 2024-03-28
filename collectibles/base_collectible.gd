class_name BaseCollectible
extends Area2D

signal collected(by: Car)

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_collected: bool = false

func _ready() -> void:
	pass

func _collect(emit_to: Car) -> void:
	collected.emit(emit_to)
		
	animation_player.play("collect")
	await animation_player.animation_finished
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	var car: Car = body as Car
	if car != null and not is_collected:
		_collect(car)


func _on_area_entered(area: Area2D) -> void:
	var collector: CarCollectorArea = area as CarCollectorArea
	if collector != null:
		_collect(collector.car)
	if area is CollectibleDestroyer:
		queue_free()
