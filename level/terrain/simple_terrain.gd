class_name SimpleTerrain
extends StaticBody2D

signal generated(x_end: float)

const VERTEX_GAP: float = 64.0
const DEEP_Y: float = 1_000_000.0

var points: PackedVector2Array = PackedVector2Array()

@export var generation_parameters: GenerationParameters
@export var fill_texture: Texture
@export var ground_texture: Texture

@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var line_2d_ground: Line2D = $Line2DGround
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

@onready var generation_border: GenerationBorder = $GenerationBorder
@onready var worldborder_l: StaticBody2D = $WorldborderL
@onready var worldborder_r: StaticBody2D = $WorldborderR
@onready var collectible_destroyer: CollectibleDestroyer = $CollectibleDestroyer

var noise: FastNoiseLite = FastNoiseLite.new()

func _ready() -> void:
	noise.seed = 42
	
	polygon_2d.texture = fill_texture
	line_2d_ground.texture = ground_texture
	
	var vertices: PackedVector2Array = get_initial_vertices()
	
	for vertex: Vector2 in vertices:
		# dont sync polygons over 100 times, just once at the end...
		_add_point_nosync(vertex)
	
	update_base_vertices()
	
	# ...here
	_sync()

func _add_point_nosync(pos: Vector2, index: int = -1) -> void:
	if index == -1:
		points.append(pos)
	else:
		points.insert(index, pos)

func _remove_point_at_nosync(index: int = -1) -> void:
	points.remove_at(index)

func _sync() -> void:
	line_2d_ground.points = points
	polygon_2d.polygon = points
	_update_collision_polygon.call_deferred(points)

func add_point(pos: Vector2, index: int = -1) -> void:
	_add_point_nosync(pos, index)
	
	_sync()

func _update_collision_polygon(points_: PackedVector2Array) -> void:
	collision_polygon_2d.polygon = points_

func get_y(for_x: float) -> float:
	return generation_parameters.get_y(for_x)

func get_first_terrain_vertex() -> Vector2:
	return points[1]

func get_last_terrain_vertex() -> Vector2:
	return points[-3]

func push_terrain_vertex() -> void:
	var last_terrain_vertex: Vector2 = get_last_terrain_vertex()
	var index_to_insert: int = points.size() - 2
	
	var x: float = last_terrain_vertex.x + VERTEX_GAP
	var y: float = get_y(x)
	
	_add_point_nosync(Vector2(x, y), index_to_insert)
	generated.emit(x)

func pop_terrain_vertex() -> void:
	var first_terrain_index: int = 1
	
	_remove_point_at_nosync(first_terrain_index)

func update_base_vertices() -> void:
	var first_terrain_vertex: Vector2 = get_first_terrain_vertex()
	var last_terrain_vertex: Vector2 = get_last_terrain_vertex()
	
	points[0] = Vector2(first_terrain_vertex.x, points[0].y)
	points[-2] = Vector2(last_terrain_vertex.x, points[-2].y)
	points[-1] = Vector2(first_terrain_vertex.x, points[-1].y)
	
	generation_border.position = last_terrain_vertex
	worldborder_l.position = first_terrain_vertex
	collectible_destroyer.position = first_terrain_vertex
	worldborder_r.position = last_terrain_vertex

func get_initial_vertices() -> PackedVector2Array:
	var count: int = 256
	var x: float = -VERTEX_GAP * 96.0
	var x_0: float = x
	
	var result: PackedVector2Array = PackedVector2Array()
	result.append(Vector2(x, DEEP_Y))
	for i: int in range(count):
		x += VERTEX_GAP
		result.append(Vector2(x, get_y(x)))
	result.append(Vector2(x, DEEP_Y))
	result.append(Vector2(x_0, DEEP_Y))
	return result

func _on_generation_border_car_entered() -> void:
	# generate multiple vertices at once without syncing polygons
	# to improve performance
	for _i: int in range(16):
		pop_terrain_vertex()
		push_terrain_vertex()
	_sync()
	update_base_vertices()
