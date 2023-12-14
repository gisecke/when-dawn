extends Sprite2D

class_name EnemyTexture

@export var animation: AnimationPlayer
@export var enemy: CharacterBody2D
@export var attack_area_collision: CollisionShape2D
@export var particles: GPUParticles2D
@export var action_sfx: AudioStreamPlayer


func animate(_velocity: Vector2) -> void:
	pass
	


func on_animation_finished(_anim_name: String):
	pass # Replace with function body.

func action_behavior() -> void:
	pass
	
func move_behavior(_velocity:Vector2) -> void:
	pass
	
func attack_behavior() -> void:
	pass

func play_action_audio(path: String) -> void:
	action_sfx.stream = load(path)
	action_sfx.play()
	
func pause_animation(pause_condition:bool) -> void:
	if pause_condition:
		animation.pause()
	else:
		animation.play()
