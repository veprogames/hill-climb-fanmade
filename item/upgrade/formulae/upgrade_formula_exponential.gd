class_name UpgradeFormulaExponential
extends UpgradeFormula

@export var base: float = 0.0
@export var multiplier: float = 1.0
@export var exponent: float = 1.0

func get_value(level: int) -> float:
	return base + multiplier * exponent ** level
