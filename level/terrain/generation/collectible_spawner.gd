class_name CollectibleSpawner
extends Node2D

@export var terrain: SimpleTerrain

var FuelScene: PackedScene = preload("res://collectibles/fuel_collectible.tscn")

var next_fuel: float = 90 * Level.PX_TO_M

func _ready() -> void:
	terrain.generated.connect(_on_terrain_generated)

func spawn_fuel(x: float) -> void:
	var y: float = terrain.get_y(x) - 192
	var fuel: FuelCollectible = FuelScene.instantiate() as FuelCollectible
	fuel.position = Vector2(x, y)
	add_child.call_deferred(fuel)

func _on_terrain_generated(x_end: float) -> void:
	if x_end >= next_fuel:
		spawn_fuel(x_end)
		next_fuel += 90 * Level.PX_TO_M
