class_name CarCamera
extends Camera2D

@export var car: Car

var car_died: bool = false
var zoom_tween: Tween

const BASE_ZOOM_NO_UPGRADES: float = 0.55

func _ready() -> void:
	zoom = get_base_zoom()
	
	car.died.connect(_on_car_died)
	car.fuel_depleted.connect(_on_car_died)
	car.refueled.connect(_on_car_refueled)

func _physics_process(delta: float) -> void:
	if not car_died:
		var zoom_multiplier: float = remap(car.linear_velocity.x, 0.0, 3000.0, 1.0, 0.75)
		zoom_multiplier = clampf(zoom_multiplier, 0.75, 1.0)
		zoom = zoom.lerp(get_base_zoom() * zoom_multiplier, delta * 2.0)

func get_base_zoom() -> Vector2:
	var zoom_level: float = BASE_ZOOM_NO_UPGRADES / car.stats.camera_zoom
	zoom_level = maxf(zoom_level, 0.4)
	return zoom_level * Vector2.ONE

func _on_car_died() -> void:
	car_died = true
	
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, ^"zoom", get_base_zoom() * 1.2, 2) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)

func _on_car_refueled(was_out_of: bool) -> void:
	if was_out_of:
		car_died = false
		
		if zoom_tween != null and zoom_tween.is_running():
			zoom_tween.kill()
