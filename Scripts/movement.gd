extends StaticBody2D

var gravity_fall_pixel_count = 1
var cobj = []
@onready
var bgs = [$"../bg3", $"../bg1", $"../bg2"]
@onready
var bgs2 = [$"../bg3", $"../bg1", $"../bg2"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.body_entered.connect(_entered)
	$Area2D.body_exited.connect(_exited)

func _entered(body):
	if(body == bgs[2]):
		bgs[0].position += Vector2(0, 648*3)
		bgs2[2] = bgs[0]
		bgs2[1] = bgs[2]
		bgs2[0] = bgs[1]
		bgs = bgs2
	if(body == bgs[0]):
		bgs[2].position -= Vector2(0, 648*3)
		bgs2[0] = bgs[2]
		bgs2[1] = bgs[0]
		bgs2[2] = bgs[1]
		bgs2 = bgs
	cobj.append(body)

func _exited(body):
	cobj.erase(body)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var touching = false
	for i in cobj:
		if(not "bg" in i.name && i != $"." && i != $"../left" && i != $"../right"):
			touching = true
	if !touching:
		position += Vector2(0, gravity_fall_pixel_count)
	if Input.is_action_pressed("ui_up"):
		position += Vector2(0, -5)
	if Input.is_action_pressed("ui_down") && !touching && not $"../ground/dirt" in cobj:
		position += Vector2(0, 5)
	if Input.is_action_pressed("ui_left") && not $"../left" in cobj:
		position += Vector2(-5, 0)
	if Input.is_action_pressed("ui_right") && not $"../right" in cobj:
		position += Vector2(5, 0)
