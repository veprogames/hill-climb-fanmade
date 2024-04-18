class_name UpgradeItemDefinition 
extends Resource

enum StatType {
	# Tier 1
	EngineAcceleration,
	WheelSize,
	FuelCapacity,
	Bounciness,
	DownwardPressure,
	AirRotationSpeed,
	# Tier 2
	CameraZoom,
	CenterOfMassX,
	Stability,
	# Tier 3
	RightwardPressure,
}

## How the Effect should be calculated with other items of that StatType
enum StatOperationType {
	Addition,
	Substraction,
	Multiplication,
	Division,
}

@export var texture: Texture
@export var title: String
@export var description: String
@export var stat: StatType
@export var operation: StatOperationType
@export var price_formula: UpgradeFormula
@export var effect_formula: UpgradeFormula
@export var base_gem_price: int = 25
@export var max_level: int = 10

func get_price(for_level: int) -> int:
	return int(price_formula.get_value(for_level))

func get_effect(for_level: int) -> float:
	return effect_formula.get_value(for_level)
