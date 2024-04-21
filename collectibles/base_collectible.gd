class_name BaseCollectible
extends Area2D

signal collected(by: Car)

@export var xp_value: int = 0
@export var collect_sound: AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_collected: bool = false

func _ready() -> void:
	pass

func _play_collect_animation() -> void:
	animation_player.play("collect")
	await animation_player.animation_finished
	queue_free()

func _try_play_collect_sound() -> void:
	if collect_sound != null:
		GlobalSound.play(collect_sound, -6.0)

func _handle_collect(car: Car) -> void:
	is_collected = true
	collected.emit(car)
	Game.save.experience.xp += xp_value
	_play_collect_animation()
	_try_play_collect_sound()

func _on_body_entered(body: Node2D) -> void:
	var car: Car = body as Car
	if car != null and not is_collected:
		_handle_collect(car)


func _on_area_entered(area: Area2D) -> void:
	var collector: CarCollectorArea = area as CarCollectorArea
	if collector != null and not is_collected:
		_handle_collect(collector.car)
	if area is CollectibleDestroyer:
		queue_free()
