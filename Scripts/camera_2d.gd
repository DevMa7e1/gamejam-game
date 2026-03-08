extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var zoom_timer = 0
var zooming_in = false
var zooming_out = false


func easeInOutCubic(x):
	if x < 0.5: 
		return 4 * x * x * x
	return 1 - pow(-2 * x + 2, 3) / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(get_parent().position[1] > 250 || get_parent().position[0] > 250):
		if zoom.x > 1 && !zooming_in && !zooming_out:
			zoom_timer = 0
			zooming_out = true
			$"../upgrade-interface/Button".hide()
	else:
		if zoom.x < 2 && !zooming_in && !zooming_out:
			zoom_timer = 0
			zooming_in = true
	if(zooming_in):
		zoom_timer += delta
		zoom = Vector2(1 + easeInOutCubic(zoom_timer/2), 1 + easeInOutCubic(zoom_timer/2))
		if(zoom_timer > 2):
			zooming_in = false
			zoom_timer = 0
			$"../upgrade-interface/Button".show()
	elif(zooming_out):
		zoom_timer += delta
		zoom = Vector2(1+(1 - easeInOutCubic(zoom_timer/2)), 1+(1 - easeInOutCubic(zoom_timer/2)))
		if(zoom_timer > 2):
			zooming_out = false
			zoom_timer = 0
