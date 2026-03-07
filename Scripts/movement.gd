extends StaticBody2D

var gravity_fall_pixel_count = 1
var cobj = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(_entered)
	$Area2D.body_exited.connect(_exited)

func _entered(body):
	print(body)
	cobj.append(body)

func _exited(body):
	cobj.erase(body)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var touching = false
	var who: Node2D
	for i in cobj:
		if(i.get_parent() == $"../ground"):
			touching = true
			who = i
			break
	if !touching:
		position += Vector2(0, gravity_fall_pixel_count)
	if Input.is_action_pressed("ui_up"):
		position += Vector2(0, -5)
