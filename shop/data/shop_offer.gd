class_name ShopOffer
extends Resource

signal bought
signal removed

@export var price: int = 0

func _init(price_: int = 0) -> void:
	price = price_

func can_afford() -> bool:
	return Game.save.gems >= price

func try_buy() -> void:
	if can_afford():
		Game.save.gems -= price
		bought.emit()
