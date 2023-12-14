extends PlayerTemplate

func action_behavior() -> void:
	if Input.is_action_pressed('attack'):
		attacking = true
		player_texture.attack = true
		play_action_audio("res://assets/sounds/axe/axe_impact.ogg")


func on_attack_area_entered(area):
	if area.get_parent().name.contains('enemy'):
		action_audio_sfx.stop()
		play_action_audio("res://assets/sounds/axe/axe_hit.ogg")
		
	

func _on_damage_area_entered(_area) -> void:
	if dead:
		play_action_audio("res://assets/sounds/hurts/hurt_man_2.ogg")
	
	elif on_hit:
		var random_number: int = randi_range(1, 5)
		var audio_path:String = "res://assets/sounds/hurts/barbarian_hurt_"+str(random_number)+'.ogg'
		play_action_audio(audio_path)
