class_name ExperienceLevelDefinition
extends RefCounted

var xp_needed: int
var title: String

func _init(title_: String, xp_needed_: int) -> void:
	title = title_
	xp_needed = xp_needed_
