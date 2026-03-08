extends Area2D

var fishnet_timer = 0
var fishing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_e)
	area_exited.connect(_x)
	body_entered.connect(_e)
	body_exited.connect(_x)

var bodies = []

func _set_net_enabled(enabled: bool) -> void:
	visible = enabled
	monitoring = enabled
	monitorable = enabled
	$CollisionShape2D.disabled = !enabled
	if !enabled:
		fishing = false
		get_child(0).texture = preload("res://Sprites/fish_net_normal_placeholder.png")
		bodies.clear()

func _get_fish_root(collider):
	if collider == null or collider == self:
		return null
	var root = collider.get_parent()
	if root == null:
		return null
	if root.has_method("get") and root.get("level") != null:
		return root
	return null

func _e(collider):
	var fish_root = _get_fish_root(collider)
	if fish_root != null and !bodies.has(fish_root):
		bodies.append(fish_root)

func _x(collider):
	var fish_root = _get_fish_root(collider)
	if fish_root != null:
		bodies.erase(fish_root)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_pos = $"../RigidBody2D".position
	position = player_pos + Vector2(50, -20)

	var is_locked_zone = player_pos.x <= 250 and player_pos.y <= -30
	_set_net_enabled(!is_locked_zone)

	if visible:
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
				$"..".le_fishes.append([i.level, i.color])
				i.queue_free()
			$"..".check_le_fishes()
			$"..".display_want()
			bodies.clear()
