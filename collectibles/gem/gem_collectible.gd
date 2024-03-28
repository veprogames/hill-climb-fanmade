class_name GemCollectible
extends BaseCollectible


func _on_collected(_by: Car) -> void:
	Game.save.gems += 1
