extends Area2D

var fishnet_timer = 0
var fishing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_e)
	area_exited.connect(_x)

var bodies = []

func _e(body):
	print(body)
	if(body != self):
		bodies.append(body)

func _x(body):
	bodies.erase(body)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(visible):
		position = $"../RigidBody2D".position + Vector2(100, -20)
		if(Input.is_action_just_pressed("fish net key")):
			get_child(0).texture = preload("res://Sprites/fishnet_placeholder.png")
			fishing = true
			fishnet_timer = 0
	if fishing:
		fishnet_timer += delta
		if(fishnet_timer > 0.4):
			get_child(0).texture = preload("res://Sprites/fish_net_normal_placeholder.png")
			fishing = false
			for i in bodies:
				$"..".le_fishes.append([i.get_parent().level, i.get_parent().size])
				i.get_parent().queue_free()
