extends EnemyTexture

func animate(velocity: Vector2) -> void:
	if enemy.dead or enemy.hit or enemy.attack:
		action_behavior()
	else:
		move_behavior(velocity)
	
func action_behavior() -> void:
	if enemy.dead:
		animation.play('dead')
		enemy.attack = false
		
		play_action_audio("res://assets/sounds/enemies/undead/Undead_Pain_dead.ogg")
		
	elif enemy.hit:
		animation.play('hit')
		enemy.attack = false
		
		play_action_audio("res://assets/sounds/enemies/undead/undead_pain_hurt.ogg")
		
	elif enemy.attack:
		animation.play('attack')
		attack_behavior()
		
func move_behavior(velocity: Vector2) -> void:
	if velocity != Vector2.ZERO:
		animation.play('run')
		
func attack_behavior() -> void:
	if enemy.player_detection and enemy.attack and enemy.attack_off:
		enemy.velocity = Vector2.ZERO
		enemy.attack_off = false
		enemy.spawn_spell()
		play_action_audio("res://assets/sounds/enemies/undead/Magic_Spell.ogg")

func on_animation_finished(anim_name: String):
	match anim_name:
		'dead':
			enemy.kill_enemy()
		'hit':
			enemy.hit = false
			enemy.set_physics_process(true)
		'kill':
			enemy.queue_free()
