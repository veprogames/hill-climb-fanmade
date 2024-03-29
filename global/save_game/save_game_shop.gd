class_name SaveGameShop
extends Resource

signal item_offer_added(offer: ShopUpgradeItemOffer)
signal item_offer_removed(offer: ShopUpgradeItemOffer)

@export var item_offers: Array[ShopUpgradeItemOffer] = []
@export var refresh_offer: ShopOffer = ShopOffer.new(100)

var definition: UpgradeItemDefinition = preload("res://item/upgrade/definitions/engine_acceleration.tres")

func _init() -> void:
	refresh_offer.bought.connect(refresh)
	
	generate_item_offers()

func generate_item_offers() -> void:
	for i: int in range(3):
		add_item_offer()

func add_item_offer() -> void:
	var offer: ShopUpgradeItemOffer = ShopUpgradeItemOffer.new(randi_range(20, 30), definition)
	offer.bought.connect(_on_item_offer_bought.bind(offer))
	item_offers.append(offer)
	item_offer_added.emit(offer)

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
