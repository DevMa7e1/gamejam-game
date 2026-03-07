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
	new_fish.color = randi_range(1, 3)
	new_fish.get_child(0).texture = load("res://Sprites/fish(1-"+str(new_fish.color)+").png")
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

func gen_customer():
	var new_customer = preload("res://customer.tscn").instantiate()
	new_customer.position = Vector2(-400, -50)
	$".".add_child(new_customer)
func _ready() -> void:
	$Area2D.body_entered.connect(_new_customer)
	for i in range(5):
		gen_fish()
	for i in range(3):
		gen_customer()

var level_probs = [1.0]
var colors = ['light blue', 'white', 'green']

var customer

func sold_a_fish(level):
	if(level+1 >= len(level_probs)):
		level_probs[0] += .05
		level_probs[level] -= .05
	else:
		level_probs[level] -= .05
		level_probs[level+1] += .05

func _new_customer(body):
	customer = body
	print(body)
	$Node2D/ItemList.clear()
	for i in range(len(level_probs)):
		if(randf() < level_probs[i]):
			$Node2D/ItemList.add_item("Fish level " + str(i+1) + " color " + colors.pick_random())

func _process(delta: float) -> void:
	time += delta
	if fish_generate_time <= time && fishes < MAX_FISH:
		gen_fish()
	if Input.is_action_just_pressed("reject customer key"):
		if(customer):
			customer.queue_free()
			gen_customer()
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
