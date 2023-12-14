extends PlayerTemplate


func action_behavior() -> void:
	if Input.is_action_pressed("attack"):
		attacking = true
		player_texture.attack = true
		play_action_audio("res://assets/sounds/sword/sword_whoosh.ogg")



func on_attack_area_entered(area):
	if area.get_parent().name.contains('enemy'):
		play_action_audio("res://assets/sounds/sword/sword_hit.ogg")
		

func _on_damage_area_entered(_area) -> void:
	if dead:
		play_action_audio("res://assets/sounds/hurts/hurt_man_2.ogg")
		
	elif on_hit:
		var random_number: int = randi_range(1, 2)
		var audio_path:String = "res://assets/sounds/hurts/knight_hurt_"+str(random_number)+'.ogg'
		play_action_audio(audio_path)
		
