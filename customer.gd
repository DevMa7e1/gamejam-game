extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.linear_velocity = Vector2(10, 0).normalized() * 200


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
