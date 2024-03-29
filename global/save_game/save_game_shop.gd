class_name SaveGameShop
extends Resource

signal item_offer_added(offer: ShopUpgradeItemOffer)
signal item_offer_removed(offer: ShopUpgradeItemOffer)

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
	add_item_offer(definition_engine)

func generate_item_offers() -> void:
	for i: int in range(3):
		add_random_item_offer()

func get_base_price() -> int:
	return int(20 * (1 + 0.3 * Game.save.garage.get_item_count()))

func add_item_offer(definition: UpgradeItemDefinition) -> void:
	var base_price: int = get_base_price()
	var top_price: int = int(base_price * 1.5)
	var price: int = randi_range(base_price, top_price)
	var offer: ShopUpgradeItemOffer = ShopUpgradeItemOffer.new(price, definition)
	offer.bought.connect(_on_item_offer_bought.bind(offer))
	item_offers.append(offer)
	item_offer_added.emit(offer)

func add_random_item_offer() -> void:
	var definition: UpgradeItemDefinition = definitions.pick_random()
	add_item_offer(definition)

func remove_item_offer(offer: ShopUpgradeItemOffer) -> void:
	if offer.bought.is_connected(_on_item_offer_bought):
		offer.bought.disconnect(_on_item_offer_bought)
	item_offers.erase(offer)
	offer.removed.emit()
	item_offer_removed.emit(offer)

func _on_item_offer_bought(offer: ShopUpgradeItemOffer) -> void:
	remove_item_offer(offer)

func refresh() -> void:
	while item_offers.size() > 0:
		remove_item_offer(item_offers[0])
	assert(item_offers.size() == 0)
	generate_item_offers()
