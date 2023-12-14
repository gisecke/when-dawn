extends EnemyTemplate

func spawn_spell() -> void:
	detection_area.monitoring = false
	var spell_path = load("res://scenes/enemies/necromancer/spell_body.tscn")
	var spell:RigidBody2D = spell_path.instantiate()
	get_parent().call_deferred("add_child", spell)
	var spell_offset:Vector2
	if not texture.is_flipped_h():
		spell_offset = Vector2(33, 2)
	elif texture.is_flipped_h():
		spell_offset = Vector2(-21, 2)
	spell.global_position = global_position + spell_offset
	spell.flip_texture(texture.is_flipped_h())
	spell.throw(direction, global_position)
	await get_tree().create_timer(2.0).timeout
	detection_area.monitoring = true
	attack = false
