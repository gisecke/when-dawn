extends EnemyTexture

func animate(velocity: Vector2) -> void:
	if enemy.dead or enemy.hit or enemy.attack:
		action_behavior()
	else:
		move_behavior(velocity)
		
func action_behavior() -> void:
	if enemy.dead:
		animation.play('dead')
		
		play_action_audio("res://assets/sounds/enemies/skeletons/skeleton_dead.ogg")
		
		enemy.attack = false
		enemy.hit = false
	if enemy.hit:
		animation.play('hit')
		
		enemy.attack = false
		var rng:int = randi_range(1, 3)
		var audio_path:String = "res://assets/sounds/enemies/skeletons/skeleton_hurt_"+str(rng)+".ogg"
		play_action_audio(audio_path)
		
	if enemy.attack and enemy.attack_off:
		animation.play('attack')
		attack_behavior()
		
		play_action_audio("res://assets/sounds/enemies/skeletons/throw_bone.ogg")
	
	
func move_behavior(velocity:Vector2) -> void:
	if velocity != Vector2.ZERO:
		animation.play('run')
		
func attack_behavior() -> void:
	if enemy.player_detection and enemy.attack and enemy.attack_off:
		enemy.velocity = Vector2.ZERO
		enemy.attack_off = false
		await get_tree().create_timer(0.2).timeout
		enemy.spawn_bone()
		
	
func on_animation_finished(anim_name: String):
	match anim_name:
		'dead':
			enemy.kill_enemy()
		'hit':
			enemy.set_physics_process(true)
			enemy.hit = false
		'kill':
			queue_free()
		'attack':
			pass
			
