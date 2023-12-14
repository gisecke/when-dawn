extends RigidBody2D

@export var animation: AnimationPlayer
@export var texture: Sprite2D
@export var life_timer:Timer

@export var force: int
@export var base_attack: int

func _ready():
	life_timer.start()

func flip_texture(is_flippedh:bool) -> void:
	if is_flippedh:
		texture.set_flip_h(true)
	else: 
		texture.set_flip_h(false)
		
func throw(direction: Vector2, enemy_position:Vector2) -> void:
	var impulse: Vector2 = direction * force 
	apply_impulse(impulse, enemy_position)


func on_to_hit_area_body_entered(body) -> void:
	if body.get_class() == 'TileMap':
		animation.play('kill')
	elif body.get_class() == 'CharacterBody2D' and body.name.contains('Player'):
		animation.play('kill')
		self.call_deferred('set_freeze_enabled', true)
		get_tree().call_group('stats', 'update_health', 'decrease', base_attack)



func on_animation_finished(anim_name):
	match anim_name:
		'kill':
			queue_free()


func on_life_timer_timeout():
	animation.play('kill')
