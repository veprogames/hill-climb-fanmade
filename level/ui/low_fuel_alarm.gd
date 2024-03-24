class_name LowFuelAlarm
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var anim_blink: Animation

func _ready() -> void:
	anim_blink = animation_player.get_animation("blink")
	
	modulate.a = 0.0

func activate() -> void:
	anim_blink.loop_mode = Animation.LOOP_LINEAR
	animation_player.play("blink")

func deactivate() -> void:
	anim_blink.loop_mode = Animation.LOOP_NONE
