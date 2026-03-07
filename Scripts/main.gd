extends Node2D

var time = 0.0
var fish_generate_time = 0

var level = 1

# Called when the node enters the scene tree for the first time.
func gen_fish():
	var new_fish = preload("res://Scenes/fish.tscn").instantiate()
	new_fish.level = randi_range(1, level)
	new_fish.position.y = randi_range((new_fish.level-1) * 648 - 32, new_fish.level * 648)
	$".".add_child(new_fish)
	fish_generate_time = time + randi_range(10, 30)
	
func _ready() -> void:
	gen_fish()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if fish_generate_time <= time:
		gen_fish()
