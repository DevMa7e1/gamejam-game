extends Node2D

var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if(time >= 1):
		$Sprite0.texture = load("res://Intro/sprite_2.png")
		$Label.text = """Trei Pătrimi /
Three Quarters"""
	elif(time >= 0.66):
		$Sprite0.texture = load("res://Intro/sprite_1.png")
		$Label.text = """Trei Pă      /
Three Quar"""
	elif(time >= 0.33):
		$Sprite0.show()
		$Label.text = """Trei         /
Three"""
	if(time >= 5):
		get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
