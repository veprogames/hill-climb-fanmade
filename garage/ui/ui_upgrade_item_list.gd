class_name UIUpgradeItemList
extends HFlowContainer

signal item_selected(item: UpgradeItem)

var garage: SaveGameGarage

var UIUpgradeItemScene: PackedScene = preload("res://garage/ui/ui_upgrade_item.tscn")

func _ready() -> void:
	garage = Game.save.garage
	
	for item: UpgradeItem in garage.inventory:
		add_item(item)

func add_item(item: UpgradeItem) -> void:
	var ui_item: UIUpgradeItem = UIUpgradeItemScene.instantiate() as UIUpgradeItem
	ui_item.item = item
	ui_item.selected.connect(_on_item_item_selected)
	add_child(ui_item)

func _on_item_item_selected(item: UpgradeItem) -> void:
	item_selected.emit(item)
