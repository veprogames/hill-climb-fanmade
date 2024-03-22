class_name Terrain
extends StaticBody2D

var noise: FastNoiseLite = FastNoiseLite.new()

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $Polygon2D

func _ready() -> void:
	noise.seed = 42
	
	var vertices: PackedVector2Array = generate()
	collision_polygon_2d.polygon = vertices
	polygon_2d.polygon = vertices

func generate() -> PackedVector2Array:
	var result = PackedVector2Array()
	result.append(Vector2(0, 10000))
	for i in range(1000):
		var x: float = i * 64.0
		var amp: float = 300 + x / 50.0
		var y: float = noise.get_noise_1d(x / 50.0) * amp + 1000
		result.append(Vector2(x, y))
	result.append(Vector2(64000, 10000))
	return result
