extends RigidBody2D

@export var speed: float = 200.0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_up") && position.y > -30.0:
		direction.y -= 10
	if Input.is_action_pressed("ui_down"):
		direction.y += 10
	if Input.is_action_pressed("ui_left"):
		direction.x -= 10
	if Input.is_action_pressed("ui_right"):
		direction.x += 10
	if direction != Vector2.ZERO:
		state.linear_velocity = direction.normalized() * speed
	else:
		state.linear_velocity = Vector2.ZERO

func _process(delta: float) -> void:
	if position.y < -20:
		$"../left/CollisionShape2D".disabled = true
	else:
		$"../left/CollisionShape2D".disabled = false
