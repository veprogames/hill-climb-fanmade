class_name Pedal
extends TextureRect

var texture_off: Texture = preload("res://level/pedal.png")
var texture_on: Texture = preload("res://level/pedal_on.png")

func activate() -> void:
	texture = texture_on

func deactivate() -> void:
	texture = texture_off
