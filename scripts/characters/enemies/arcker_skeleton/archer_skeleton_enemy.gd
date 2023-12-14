extends EnemyTemplate


func spawn_arrow() -> void:
	detection_area.monitoring = false
	var arrow_path = load("res://scenes/enemies/archer_skeleton/arrow_body.tscn")
	var arrow_body: RigidBody2D = arrow_path.instantiate()
	get_parent().call_deferred("add_child", arrow_body)
	
	var position_arrow:Vector2
	if texture.flip_h:
		position_arrow = Vector2(-10 , -1)
	elif not texture.flip_h:
		position_arrow = Vector2(10 , -1)
	arrow_body.global_position = global_position + position_arrow
	arrow_body.throw(direction)
	arrow_body.change_texture(direction)
	await get_tree().create_timer(2.0).timeout
	attack = false
	detection_area.monitoring = true
