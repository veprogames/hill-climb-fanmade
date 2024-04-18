class_name SaveGameShop
extends Resource

signal item_offer_added(offer: ShopUpgradeItemOffer)
signal item_offer_removed(offer: ShopUpgradeItemOffer)

signal item_offer_pressed(offer: ShopUpgradeItemOffer)

@export var item_offers: Array[ShopUpgradeItemOffer] = []
@export var refresh_offer: ShopOffer = ShopOffer.new(100)

var definition_engine: UpgradeItemDefinition = preload("res://item/upgrade/definitions/engine_acceleration.tres")

var definitions: Array[UpgradeItemDefinition] = [
	definition_engine,
	preload("res://item/upgrade/definitions/wheel_size.tres"),
	preload("res://item/upgrade/definitions/fuel_capacity.tres"),
	preload("res://item/upgrade/definitions/bounciness.tres"),
	preload("res://item/upgrade/definitions/downward_pressure.tres"),
	preload("res://item/upgrade/definitions/air_rotation_speed.tres"),
]

func initialize() -> void:
	generate_item_offers()

func generate_item_offers() -> void:
	var items: Array[UpgradeItemDefinition] = Array(definitions)
	items.shuffle()
	for definition: UpgradeItemDefinition in items.slice(0, 3):
		add_item_offer(definition)

func get_price_multiplier() -> float:
	return clampf(1 + 0.3 * Game.save.garage.get_item_count(), 1.0, 4.0)

func add_item_offer(definition: UpgradeItemDefinition) -> void:
	var base_price: int = int(definition.base_gem_price * get_price_multiplier())
	var top_price: int = int(base_price * 1.1)
	var price: int = randi_range(base_price, top_price)
	var offer: ShopUpgradeItemOffer = ShopUpgradeItemOffer.new(price, definition)
	item_offers.append(offer)
	item_offer_added.emit(offer)

func add_random_item_offer() -> void:
	var definition: UpgradeItemDefinition = definitions.pick_random()
	add_item_offer(definition)

func remove_item_offer(offer: ShopUpgradeItemOffer) -> void:
	item_offers.erase(offer)
	offer.removed.emit()
	item_offer_removed.emit(offer)

func refresh() -> void:
	while item_offers.size() > 0:
		remove_item_offer(item_offers[0])
	assert(item_offers.size() == 0)
	generate_item_offers()
