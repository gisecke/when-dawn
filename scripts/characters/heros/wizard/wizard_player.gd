extends PlayerTemplate


func action_behavior() -> void:
	if Input.is_action_just_pressed("attack") and not attacking:
		attacking = true
		player_texture.attack = true
		play_action_audio("res://assets/sounds/magic_wizard/lightining_spell.ogg")
		
		spawn_lightning()
		
func spawn_lightning() -> void:
	var lightning_path:PackedScene = load("res://scenes/heros/Wizard/spawn_lightning.tscn")
	var lightning:Marker2D = lightning_path.instantiate()
	get_parent().call_deferred('add_child', lightning)
	if Global.enemy != null:
		var enemy: CharacterBody2D = get_parent().find_child('*Enemy', true, false)
		if enemy != null and enemy.is_on_screen and !enemy.dead:
			lightning.global_position = enemy.global_position
		else:
			var enemies:Array = get_parent().find_children('@Character*', '', true, false)

			for e in enemies:
				if e.is_on_screen and !e.dead:
					lightning.global_position = e.global_position
					return
			lightning.global_position = self.global_position + Vector2(100, 0)
				
	else:
		lightning.global_position = self.global_position + Vector2(100, 0)
			

func _on_damage_area_entered(_area):
	if dead:
		play_action_audio("res://assets/sounds/hurts/hurt_man_2.ogg")
	elif on_hit:
		var random_number: int = randi_range(1, 2)
		var audio_path:String = "res://assets/sounds/hurts/wizard_hurt_"+str(random_number)+'.ogg'
		play_action_audio(audio_path)
