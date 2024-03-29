class_name SaveGameShop
extends Resource

@export var item_offers: Array[ShopUpgradeItemOffer] = []
@export var refresh_offer: ShopOffer = ShopOffer.new(100)

var definition: UpgradeItemDefinition = preload("res://item/upgrade/definitions/engine_acceleration.tres")

func _init() -> void:
	refresh_offer.bought.connect(refresh)
	
	item_offers = generate_item_offers()

func generate_item_offers() -> Array[ShopUpgradeItemOffer]:
	var offers: Array[ShopUpgradeItemOffer] = []
	
	for i: int in range(3):
		offers.append(ShopUpgradeItemOffer.new(randi_range(20, 30), definition))
	
	return offers

func refresh() -> void:
	item_offers = generate_item_offers()
