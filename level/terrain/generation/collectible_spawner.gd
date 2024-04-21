class_name CollectibleSpawner
extends Node2D

@export var terrain: SimpleTerrain
@export var parameters: CollectibleGenerationParameters

@onready var fuel_container: Node2D = $Fuel
@onready var coins_container: Node2D = $Coins
@onready var gems_container: Node2D = $Gems

var FuelScene: PackedScene = preload("res://collectibles/fuel/fuel_collectible.tscn")
var CoinScene: PackedScene = preload("res://collectibles/coin/coin_collectible.tscn")
var GemScene: PackedScene = preload("res://collectibles/gem/gem_collectible.tscn")

var fuels_spawned: int = 0
var coin_formations_spawned: int = 0
var gems_spawned: int = 0

func _ready() -> void:
	# pregenerate
	while get_next_coins() / Level.PX_TO_M < 200:
		spawn_coins(get_next_coins())
	while get_next_gems() / Level.PX_TO_M < 200:
		spawn_gems(get_next_gems())
	spawn_fuel(get_next_fuel())
	
	terrain.generated.connect(_on_terrain_generated)

# either manually define a y position for possible caching

func spawn_collectible_at(packed_collectible: PackedScene, x: float, y: float) -> BaseCollectible:
	var collectible: BaseCollectible = packed_collectible.instantiate() as BaseCollectible
	collectible.position = Vector2(x, y)
	
	return collectible

# or let y be calculated

func spawn_collectible_at_x(packed_collectible: PackedScene, x: float) -> BaseCollectible:
	var y: float = terrain.get_y(x) - 192
	
	return spawn_collectible_at(packed_collectible, x, y)

func spawn_fuel(x: float) -> void:
	var fuel: FuelCollectible = spawn_collectible_at_x(FuelScene, x)
	
	fuel_container.add_child.call_deferred(fuel)
	
	fuels_spawned += 1

func get_next_fuel() -> float:
	return parameters.get_fuel_position_in_meters(fuels_spawned + 1) * Level.PX_TO_M

func get_closest_fuel(from_x: float) -> FuelCollectible:
	var children: Array[Node] = fuel_container.get_children()
	if children.size() == 0:
		return null
	var filtered: Array[Node] = children.filter(func(child: Node) -> bool:
		var collectible: BaseCollectible = child as BaseCollectible
		return collectible != null and collectible.position.x >= from_x and !collectible.is_collected
	)
	if filtered.size() == 0:
		return null
	return filtered[0]

func spawn_coins(x: float) -> void:
	var total_value: int = parameters.get_coins_value(coin_formations_spawned)
	var values: Array[int] = get_coin_values(total_value)
	
	var nth_x: int = 0
	var offset: Vector2 = Vector2.ZERO
	
	## cache y values for each x
	var cached_y: Array[float] = []
	
	for value: int in values:
		# to reduce calls to get_y
		var y: float = 0.0
		if cached_y.size() >= nth_x + 1:
			y = cached_y[nth_x]
		else:
			y = terrain.get_y(x + offset.x) - 192
			cached_y.append(y)
		
		var coin: CoinCollectible = spawn_collectible_at(CoinScene, x + offset.x, y) as CoinCollectible
		coin.position.y += offset.y
		coin.value = value
		
		coins_container.add_child.call_deferred(coin)
		
		nth_x += 1
		
		offset.x += 192.0
		if nth_x > 4:
			nth_x = 0
			offset.x = 0.0
			offset.y -= 192.0
	
	coin_formations_spawned += 1

func get_coin_values(total: int) -> Array[int]:
	var result: Array[int] = []
	var values: Array[int] = [250, 50, 10, 5, 1]
	var values_index: int = 0
	while result.size() < 10:
		var current_value: int = values[values_index]
		while total < current_value:
			values_index += 1
			current_value = values[values_index]
		
		while total >= current_value:
			total -= current_value
			result.append(current_value)
			
			if result.size() >= 10:
				break
		
		if total == 0:
			break
	return result

func get_next_coins() -> float:
	return parameters.get_coin_position_in_meters(coin_formations_spawned + 1) * Level.PX_TO_M

func spawn_gems(x: float) -> void:
	var gem: GemCollectible = spawn_collectible_at_x(GemScene, x) as GemCollectible
	
	gems_container.add_child.call_deferred(gem)
	
	gems_spawned += 1

func get_next_gems() -> float:
	return parameters.get_gem_position_in_meters(gems_spawned + 1) * Level.PX_TO_M

func _on_terrain_generated(x_end: float) -> void:
	var next_fuel: float = get_next_fuel()
	
	if x_end >= next_fuel:
		spawn_fuel(x_end)
		next_fuel += 90 * Level.PX_TO_M
	
	var next_coins: float = get_next_coins()
	
	if x_end >= next_coins:
		spawn_coins(x_end)
	
	var next_gems: float = get_next_gems()
	
	if x_end >= next_gems:
		spawn_gems(x_end)
