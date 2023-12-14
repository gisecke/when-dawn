extends EnemyTemplate

func spawn_bone() -> void:
	detection_area.monitoring = false
	var bone_path = preload("res://scenes/enemies/skeleton/bone_body.tscn")
	var bone:RigidBody2D = bone_path.instantiate()
	get_parent().call_deferred("add_child", bone)
	var position_bone: Vector2
	if texture.is_flipped_h():
		position_bone = Vector2(-14, -8)
	elif not texture.is_flipped_h():
		position_bone = Vector2(14, -8)
	bone.global_position = global_position + position_bone
	bone.throw(direction, global_position)
	bone.change_animation(direction)
	await get_tree().create_timer(2.0).timeout
	detection_area.monitoring = true
	attack = false
