class_name CarCamera
extends Camera2D

@export var car: Car

var car_died: bool = false
var zoom_tween: Tween

const BASE_ZOOM: Vector2 = Vector2.ONE * 0.55

func _ready() -> void:
	zoom = BASE_ZOOM
	
	car.died.connect(_on_car_died)
	car.fuel_depleted.connect(_on_car_died)
	car.refueled.connect(_on_car_refueled)

func _physics_process(delta: float) -> void:
	if not car_died:
		var zoom_multiplier: float = remap(car.linear_velocity.x, 0.0, 3000.0, 1.0, 0.75)
		zoom_multiplier = clampf(zoom_multiplier, 0.75, 1.0)
		zoom = zoom.lerp(BASE_ZOOM * zoom_multiplier, delta * 2.0)

func _on_car_died() -> void:
	car_died = true
	
	zoom_tween = create_tween()
	zoom_tween.tween_property(self, ^"zoom", BASE_ZOOM * 1.2, 2) \
		.set_ease(Tween.EASE_OUT) \
		.set_trans(Tween.TRANS_CUBIC)

func _on_car_refueled(was_out_of: bool) -> void:
	if was_out_of:
		car_died = false
		
		if zoom_tween != null and zoom_tween.is_running():
			zoom_tween.kill()
