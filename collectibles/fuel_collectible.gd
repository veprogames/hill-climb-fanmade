class_name FuelCollectible
extends BaseCollectible

func _on_collected(by: Car) -> void:
	by.fuel = 1.0
