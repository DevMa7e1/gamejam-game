extends Node2D

const FISH_SCENE := preload("res://Scenes/fish.tscn")
const FISH_GROUP := "fish"
@export var MAX_FISH: int = 20 # CONSTANT

var time = 719.0
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
	new_fish.set_color()
	new_fish.position.x = randi_range((new_fish.level-1) * 1920 + 50, new_fish.level * 1920)
	new_fish.position.y = randi_range((new_fish.level-1) * 1080 + 50, new_fish.level * 1080)
	new_fish.scale = Vector2(1 + new_fish.level*0.2, 1 + new_fish.level*0.2)
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

var level_probs = [1.0]
var colors = ['red', 'orange', 'pink', 'purple']

var money = 0

var customer

func sold_a_fish(level):
	if(level+1 >= len(level_probs)):
		level_probs[0] += .05
		level_probs[level-1] -= .05
	else:
		level_probs[level-1] -= .05
		level_probs[level] += .05

var dem_fishes_that_they_want = []

func check_le_fishes():
	for i in dem_fishes_that_they_want:
		i[2] = 0
	for i in dem_fishes_that_they_want:
		for j in le_fishes:
			if i[0] == j[0] && i[1] == j[1]:
				i[2] += 1

func display_want():
	$Node2D/ItemList.clear()
	for i in dem_fishes_that_they_want:
		$Node2D/ItemList.add_item("Fish level " + str(i[0]) + " color " + colors[i[1]] + " (you have "+str(i[2])+")")

func _new_customer(body):
	customer = body
	print(body)
	$Node2D/ItemList.clear()
	dem_fishes_that_they_want.clear()
	for i in range(len(level_probs)):
		if(randf() < level_probs[i]):
			var color = colors.pick_random()
			var have = 0
			for j in le_fishes:
				if j[0] == level && j[1] == colors.find(color):
					have += 1
			dem_fishes_that_they_want.append([i+1, colors.find(color), have])
			display_want()

func _process(delta: float) -> void:
	time += delta
	if fish_generate_time <= time && fishes < MAX_FISH:
		gen_fish()
	if Input.is_action_just_pressed("reject customer key") && day:
		if(customer):
			customer.queue_free()
			if(day):
				gen_customer()
	if Input.is_action_just_pressed("customer key"):
		var ok = true
		for i in dem_fishes_that_they_want:
			if(i[2] < 1):
				ok = false
		if(ok):
			customer.queue_free()
			if(day):
				gen_customer()
			for i in dem_fishes_that_they_want:
				money += randi_range(i[0]*100-100, i[0]*100)
				sold_a_fish(i[0])
				le_fishes.erase([i[0], i[1]])
				update_money()
	if Input.is_action_just_pressed("ui_accept"):
		print_all_fish_positions()
	if(day && time-last_cycle_time >= 60*2):
		last_cycle_time = time
		day = false
	elif(!day && time-last_cycle_time >= 60*2):
		last_cycle_time = time
		day = true
		for i in range(3):
			gen_customer()
	if(day):
		$NightBg.self_modulate.a = (time-last_cycle_time) / (60*2)
	else:
		$NightBg.self_modulate.a = 1 - (time-last_cycle_time) / (60*2)


func _on_button_3_pressed() -> void:
	$"RigidBody2D/upgrade-interface/Panel".hide()


func _on_button_pressed() -> void:
	$"RigidBody2D/upgrade-interface/Panel".show()

var money_to_upgrade_the_net = 100
var money_to_upgrade_oxygen = 200
var money_to_upgrade_level = 500

func update_money():
	$"RigidBody2D/upgrade-interface/Panel/Label3".text = str(money) + " money"

func _on_button_pressed2() -> void:
	if(money >= money_to_upgrade_the_net):
		money -= money_to_upgrade_the_net
		$fishnet.scale[0] += 0.1
		update_money()


func _on_button_2_pressed() -> void:
	if(money >= money_to_upgrade_oxygen):
		money -= money_to_upgrade_oxygen
		$RigidBody2D.oxygen_decrease * .8
		update_money()


func _on_button_4_pressed() -> void:
	if(money >= money_to_upgrade_level):
		money -= money_to_upgrade_level
		level += 1
		$ground.position += Vector2(0, 1080)
		var new_bg = $OceanBg2.duplicate()
		new_bg.position += Vector2(0, 1080 / 5 * 10 * (level-1))
		$"..".add_child(new_bg)
		level_probs.append(0.5)
		update_money()
