extends Sprite2D

class_name TexturePlayer

signal game_over

@export var player: CharacterBody2D
@export var animation:AnimationPlayer
@export var animation_invencibility: AnimationPlayer
@export var attack_area_collision: CollisionShape2D
@export var damage_area_collision: CollisionShape2D
@export var stats:Node2D


var attack: bool = false
var suffix:String = '_right'


func animate(direction: Vector2) -> void:
	if player.attacking and attack:
		attack_behavior()
	else:
		verify_speed(direction)

func attack_behavior() -> void:
	animation.play('attack'+suffix)
	animation.speed_scale = stats.bonus_attack_velocity

func verify_speed(direction: Vector2) -> void:
	if player.dead or player.on_hit:
		hit_behavior()
		
	elif direction == Vector2.ZERO or player.get_real_velocity() == Vector2.ZERO:
		animation.play('idle')
	
	elif not animation.current_animation == 'attack'+suffix:
		animation.play('run')
		if direction == Vector2.RIGHT:
			flip_h = false
			suffix = '_right'
		elif direction == Vector2.LEFT:
			flip_h = true
			suffix = '_left'
		elif direction < Vector2.ZERO and direction >=  Vector2(-1, -1):
			flip_h = true
			suffix = '_left'
		elif direction > Vector2.ZERO and direction <= Vector2.ONE:
			flip_h = false
			suffix = '_right'
			
	
func hit_behavior() -> void:
	player.set_physics_process(false)
	if player.dead:
		animation.play('dead')
		attack_area_collision.set_deferred('disabled', true)
	elif player.on_hit:
		animation.play('hit')
		attack_area_collision.set_deferred('disabled', true)
		damage_area_collision.set_deferred('disabled', true)
		


func on_animation_finished(anim_name:String) -> void:
	match anim_name:
		'attack_right':
			player.attacking = false
			attack = false
			animation.speed_scale = 1.0
		'attack_left':
			player.attacking = false
			attack = false
			animation.speed_scale = 1.0
		'hit':
			player.on_hit = false
			player.set_physics_process(true)
			animation_invencibility.play('invencibility')
		'dead':
			emit_signal("game_over")
			

func on_animation_invencibility_finished(anim_name: String) -> void:
	if anim_name == 'invencibility':
		damage_area_collision.set_deferred('disabled', false)
		
func pause_animation(pause_condition:bool) -> void:
	if pause_condition:
		animation.pause()
	else:
		animation.play()
