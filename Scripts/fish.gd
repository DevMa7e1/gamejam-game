extends Node2D

var color = 0
var level = 1
var target: Vector2

@export var wander_speed: float = 180.0
@export var min_wander_distance: float = 250.0
@export var max_wander_distance: float = 700.0
@export var arrive_distance: float = 12.0

func get_level_bounds() -> Rect2:
	var min_x = (level - 1) * 1920 + 50
	var max_x = level * 1920
	var min_y = (level - 1) * 1080 + 50
	var max_y = level * 1080
	return Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))

func choose_target() -> Vector2:
	var bounds = get_level_bounds()
	var angle = randf() * TAU
	var distance = randf_range(min_wander_distance, max_wander_distance)
	var candidate = position + Vector2.RIGHT.rotated(angle) * distance

	candidate.x = clamp(candidate.x, bounds.position.x, bounds.end.x)
	candidate.y = clamp(candidate.y, bounds.position.y, bounds.end.y)

	if candidate.distance_to(position) < min_wander_distance * 0.5:
		candidate = Vector2(
			randf_range(bounds.position.x, bounds.end.x),
			randf_range(bounds.position.y, bounds.end.y)
		)

	return candidate

func wander(delta: float) -> void:
	position = position.move_toward(target, wander_speed * delta)
	if position.distance_to(target) <= arrive_distance:
		target = choose_target()

func set_color():
	if color == 0:
		$AnimatedSprite2D.animation = "red"
	elif color == 1:
		$AnimatedSprite2D.animation = "orange"
	elif color == 2:
		$AnimatedSprite2D.animation = "pink"
	elif color == 4:
		$AnimatedSprite2D.animation = "purple"

func _ready() -> void:
	target = choose_target()

func _process(delta: float) -> void:
	wander(delta)
