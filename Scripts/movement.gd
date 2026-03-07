extends StaticBody2D

var gravity_fall_pixel_count = 1
var cobj = []
@onready
var bgs = [$"../bg3", $"../bg1", $"../bg2"]
var bgt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(_entered)
	$Area2D.body_exited.connect(_exited)

func _entered(body):
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
	if Input.is_action_pressed("ui_down") && not $"../ground/dirt" in cobj:
		position += Vector2(0, 5)
	if Input.is_action_pressed("ui_left") && not $"../left" in cobj:
		position += Vector2(-5, 0)
	if Input.is_action_pressed("ui_right") && not $"../right" in cobj:
		position += Vector2(5, 0)
