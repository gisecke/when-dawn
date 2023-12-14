extends EnemyTexture



func animate(velocity: Vector2) -> void:
	if enemy.dead or enemy.hit or enemy.attack:
		action_behavior()
	else:
		move_behavior(velocity)
		
func move_behavior(velocity: Vector2) -> void:
	if velocity != Vector2.ZERO:
		animation.play('run')
	
func action_behavior() -> void:
	if enemy.dead:
		animation.play('dead')
		enemy.attack = false
		
		play_action_audio("res://assets/sounds/enemies/wolf/wolf_dead.ogg")
		
	elif enemy.hit:
		animation.play('hit')
		enemy.attack = false
		
		play_action_audio("res://assets/sounds/enemies/wolf/wolf_hurt.ogg")
		
	elif enemy.attack:
		if is_flipped_h():
			animation.play('attack_left')
		else:
			animation.play('attack_right')
		attack_behavior()
		play_action_audio("res://assets/sounds/enemies/wolf/wolf_attack.ogg")
		
func attack_behavior() -> void:
	if enemy.player_detection and enemy.attack and enemy.attack_off:
		enemy.velocity = Vector2.ZERO
		await get_tree().create_timer(0.3).timeout
		enemy.attack_off = false
		enemy.speed = enemy.last_speed*2
		enemy.velocity = enemy.direction * enemy.speed
		
	after_attack_behavior()
		
func after_attack_behavior() -> void:
	if not enemy.player_detection and enemy.attack:
		await get_tree().create_timer(0.3).timeout
		enemy.velocity = Vector2.ZERO
		enemy.speed = enemy.last_speed
		enemy.attack = false


func on_animation_finished(anim_name: String):
	match anim_name:
		'dead':
			enemy.kill_enemy()
		'hit':
			enemy.hit = false
			enemy.set_physics_process(true)
		'kill':
			enemy.queue_free()

