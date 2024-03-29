class_name UIShopOffer
extends Button

@export var offer: ShopOffer : set = _set_offer

func _set_offer(offer_: ShopOffer) -> void:
	offer = offer_
	
	if not is_node_ready():
		await ready
	
	text = F.F(offer.price)

func _on_pressed() -> void:
	offer.try_buy()
