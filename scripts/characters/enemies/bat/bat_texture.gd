extends EnemyTexture

func animate(velocity: Vector2) -> void:
	if enemy.hit or enemy.dead or enemy.attack:
		action_behavior()
	else:
		move_behavior(velocity)

func action_behavior() -> void:
	if enemy.dead:
		animation.play('dead')
		enemy.hit = false
		enemy.attack = false
		play_action_audio("res://assets/sounds/enemies/bat/bat_dead.ogg")
	elif enemy.hit:
		animation.play('hit')
		enemy.attack = false
	elif enemy.attack:
		animation.play('attack')
		attack_behavior()
		
func move_behavior(velocity: Vector2) -> void:
	if velocity != Vector2.ZERO:
		animation.play('run')
		

func attack_behavior() -> void:
	if enemy.player_detection and enemy.attack and enemy.attack_off:
		enemy.velocity = Vector2.ZERO
		enemy.walking_sfx.stop()
		await get_tree().create_timer(0.7).timeout
		play_action_audio("res://assets/sounds/enemies/bat/little_throw.ogg")
	
		
		
		attack_area_collision.disabled = false
		enemy.attack_off = false
		enemy.speed = enemy.last_speed*3
		enemy.velocity = enemy.direction * enemy.speed
		particles.emitting = true
		
	after_attack_behavior()
		
func after_attack_behavior() -> void:
	if not enemy.player_detection and enemy.attack:
		await get_tree().create_timer(0.3).timeout
		enemy.velocity = Vector2.ZERO
		enemy.speed = enemy.last_speed
		enemy.attack = false
		attack_area_collision.disabled = true
		

func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		'dead':
			enemy.kill_enemy()
		'hit':
			enemy.set_physics_process(true)
			enemy.hit = false
		'kill':
			enemy.queue_free()
		'attack':
			enemy.attack_off = false
			
		
