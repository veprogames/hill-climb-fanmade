class_name Pedal
extends TextureRect

var texture_off: Texture = preload("res://level/ui/pedal/pedal_off.png")
var texture_on: Texture = preload("res://level/ui/pedal/pedal_on.png")

func activate() -> void:
	texture = texture_on

func deactivate() -> void:
	texture = texture_off
