extends RigidBody2D

@export var animation: AnimationPlayer
@export var life_timer:Timer

@export var force:int
@export var base_attack:int

func _ready():
	life_timer.start()

func throw(direction: Vector2, throw_position:Vector2) -> void:
	var impulse: Vector2 
	impulse = direction * force
	apply_impulse(impulse, throw_position)
	
	
func change_animation(direction: Vector2) -> void:
	if direction.x < 0:
		animation.play_backwards('play')
	elif direction.x > 0:
		animation.play('play')


func on_to_hit_area_entered(body):
	if body.get_class() == 'TileMap':
		animation.play('kill')
	elif body.get_class() == 'CharacterBody2D' and body.name.contains('Player'):
		self.call_deferred('set_freeze_enabled', true)
		get_tree().call_group('stats', 'update_health', 'decrease', base_attack)
		animation.play('kill')


func on_life_timer_timeout() -> void:
	animation.play('kill')


func _on_animation_animation_finished(anim_name):
	match anim_name:
		'kill':
			queue_free()
