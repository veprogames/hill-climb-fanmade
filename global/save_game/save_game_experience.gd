class_name SaveGameExperience
extends Resource

signal xp_changed(to_xp: int)
signal level_changed(to_level: int)

@export var xp: int = 0 : set = _set_xp
# No need to save this because it's dynamically calculated
var current_level: int = 0

var levels: Array[ExperienceLevelDefinition] = [
	ExperienceLevelDefinition.new("Rookie", 0),
	ExperienceLevelDefinition.new("Novice", 10_000),
	ExperienceLevelDefinition.new("Seasoned", 25_000),
	ExperienceLevelDefinition.new("Veteran", 40_000),
	ExperienceLevelDefinition.new("Expert", 70_000),
	ExperienceLevelDefinition.new("Grandmaster", 120_000),
	ExperienceLevelDefinition.new("Ultimate", 200_000),
]

func _get_current_level() -> int:
	for i: int in range(levels.size() - 1, 0, -1):
		var level: ExperienceLevelDefinition = levels[i]
		if xp >= level.xp_needed:
			return i
	return 0

func get_current_title() -> String:
	return levels[current_level].title

func get_xp_on_current_level() -> int:
	var level: int = mini(current_level, levels.size() - 2)
	var current_level_xp: int = levels[level].xp_needed
	return xp - current_level_xp

func get_percentage_to_next_level() -> float:
	if current_level >= levels.size() - 1:
		return 1
	
	var current_level_xp: int = levels[current_level].xp_needed
	var next_level_xp: int = levels[current_level + 1].xp_needed
	return remap(xp, current_level_xp, next_level_xp, 0.0, 1.0)

func _set_xp(xp_: int) -> void:
	var old_level: int = current_level
	xp = xp_
	current_level = _get_current_level()
	
	xp_changed.emit(xp_)
	if current_level != old_level:
		level_changed.emit(current_level)
