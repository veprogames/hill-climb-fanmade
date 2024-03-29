class_name UpgradeItemDefinition 
extends Resource

enum StatType {
	EngineAcceleration,
}

## How the Effect should be calculated with other items of that StatType
enum StatOperationType {
	Addition,
}

@export var texture: Texture
@export var title: String
@export var description: String
@export var stat: StatType
@export var operation: StatOperationType
@export var price_formula: UpgradeFormula
@export var effect_formula: UpgradeFormula
@export var max_level: int = 10

func get_price(for_level: int) -> int:
	return int(price_formula.get_value(for_level))

func get_effect(for_level: int) -> float:
	return effect_formula.get_value(for_level)
