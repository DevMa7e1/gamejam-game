extends Node2D

const FISH_SCENE := preload("res://Scenes/fish.tscn")
const FISH_GROUP := "fish"
@export var MAX_FISH: int = 20 # CONSTANT

var time = 0.0
var day = true
var last_cycle_time = 0
var fish_generate_time = 0

var fishes = 0

var level = 1

var le_fishes = []

func gen_fish():
	var new_fish = FISH_SCENE.instantiate()
	new_fish.level = randi_range(1, level)
	new_fish.position.x = randi_range((new_fish.level-1) * 1920 + 50, new_fish.level * 1920)
	new_fish.position.y = randi_range((new_fish.level-1) * 1080 + 50, new_fish.level * 1080)
	new_fish.add_to_group(FISH_GROUP)
	add_child(new_fish)
	fish_generate_time = time + randi_range(10, 30)
	fishes += 1

func get_all_fish_positions() -> Array[Vector2]:
	var fish_positions: Array[Vector2] = []
	for fish in get_tree().get_nodes_in_group(FISH_GROUP):
		if fish is Node2D:
			fish_positions.append((fish as Node2D).global_position)
	return fish_positions

func print_all_fish_positions() -> void:
	var fish_positions = get_all_fish_positions()
	for i in range(fish_positions.size()):
		print("Fish ", i, " position: ", fish_positions[i])
	if fish_positions.is_empty():
		print("No fish found")
	print("Fish count:", fishes)


func _ready() -> void:
	for i in range(5):
		gen_fish()

func _process(delta: float) -> void:
	time += delta
	if fish_generate_time <= time && fishes < MAX_FISH:
		gen_fish()

	if Input.is_action_just_pressed("ui_accept"):
		print_all_fish_positions()
	if(day && time-last_cycle_time >= 60*12):
		last_cycle_time = time
		day = false
	elif(!day && time-last_cycle_time >= 60*12):
		last_cycle_time = time
		day = true
	if(day):
		$NightBg.self_modulate.a = (time-last_cycle_time) / (60*12)
	else:
		$NightBg.self_modulate.a = 1 - (time-last_cycle_time) / (60*12)
