class_name ShopUpgradeItemOffer
extends ShopOffer

signal item_bought(item: UpgradeItem)

@export var definition: UpgradeItemDefinition = null

func _init(price_: int = 0, definition_: UpgradeItemDefinition = null) -> void:
	super._init(price_)
	definition = definition_
	
	bought.connect(_on_bought)

func _on_bought() -> void:
	var item: UpgradeItem = UpgradeItem.new(definition)
	item_bought.emit(item)
	removed.emit()
