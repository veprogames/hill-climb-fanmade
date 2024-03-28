class_name CollectibleSpawner
extends Node2D

@export var terrain: SimpleTerrain
@export var parameters: CollectibleGenerationParameters

var FuelScene: PackedScene = preload("res://collectibles/fuel_collectible.tscn")

var fuels_spawned: int = 0

func _ready() -> void:
	terrain.generated.connect(_on_terrain_generated)

func spawn_fuel(x: float) -> void:
	var y: float = terrain.get_y(x) - 192
	
	var fuel: FuelCollectible = FuelScene.instantiate() as FuelCollectible
	fuel.position = Vector2(x, y)
	add_child.call_deferred(fuel)
	
	fuels_spawned += 1

func get_next_fuel() -> float:
	return parameters.get_fuel_position_in_meters(fuels_spawned + 1) * Level.PX_TO_M

func get_closest_fuel() -> FuelCollectible:
	var children: Array[Node] = get_children()
	if children.size() == 0:
		return null
	return children[0]

func _on_terrain_generated(x_end: float) -> void:
	var next_fuel: float = get_next_fuel()
	
	if x_end >= next_fuel:
		spawn_fuel(x_end)
		next_fuel += 90 * Level.PX_TO_M
