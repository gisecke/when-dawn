extends RigidBody2D

class_name ArrowRigidBody

signal used_arrow

@export var texture_sprite:Sprite2D
@export var collision_shape:CollisionShape2D
@export var to_hit_collision:CollisionShape2D
@export var animation: AnimationPlayer
@export var life_timer_arrow: Timer

@export var force: int
@export var base_attack: int

var retangle_shape_horizontal:Shape2D = preload("res://shapes/arrow/rectangle_shape_horizontal.tres")
var retangle_shape_vertical:Shape2D = preload("res://shapes/arrow/rectangle_shape_vertical.tres")
var to_hit_shape:Shape2D = preload("res://shapes/arrow/to_hit_retangle_shape.tres")
var skeleton_enemy: CharacterBody2D


func _ready():
	var root:Array = get_tree().root.get_children()
	for child in root:
		if child.name.contains('Level'):
			skeleton_enemy =  child.find_child('ArcherSkeletonEnemy')
	
	verify_direction()
	life_timer_arrow.start()
	

func verify_direction() -> void:
	if skeleton_enemy != null:
		var texture_enemy = skeleton_enemy.get_node('Texture')
		if texture_enemy.flip_h:
			texture_sprite.flip_h = true
		else:
			texture_sprite.flip_h = false
			

		
func throw(direction: Vector2) -> void:
	texture_sprite.frame_coords = Vector2i(1, 0)
	var impulse: Vector2
	impulse = direction * force
	apply_impulse(impulse)
	
	

func change_texture(direction: Vector2) -> void:
	if direction.x < -0.5 and direction.y > 0.5:
		#O player está abaixo e a esquerda do enemy
		texture_sprite.frame_coords = Vector2i(2, 0)
		texture_sprite.flip_v = true
		texture_sprite.flip_h = true
		
	elif direction.x < -0.5 and direction.y > -0.5 and direction.y < 0.5:
		texture_sprite.frame_coords = Vector2i(1, 0)
		texture_sprite.flip_v = false
		texture_sprite.flip_h = true
		
		
	elif direction.x < -0.5 and direction.y < -0.5:
		#O player está acima e a esquerda do enemy
		texture_sprite.frame_coords = Vector2i(2, 0)
		texture_sprite.flip_v = false
		texture_sprite.flip_h = true
		
	elif direction.x > 0.5 and direction.y < -0.5:
		#O player está acima e a direita do enemy
		texture_sprite.frame_coords = Vector2i(2, 0)
		texture_sprite.flip_v = false
		texture_sprite.flip_h = false
		
	elif direction.x > 0.5 and direction.y > 0.5:
		#O player está abaixo e a direita do enemy
		texture_sprite.frame_coords = Vector2i(2, 0)
		texture_sprite.flip_v = true
		texture_sprite.flip_h = false
		
	elif direction.x > -0.5 and direction.x < 0.5  and direction.y < 0:
		#O player está acima e a esquerda do enemy (topdown)
		texture_sprite.frame_coords = Vector2i(0, 0)
		texture_sprite.flip_v = false
		texture_sprite.flip_h = true
		
		
	elif direction.x < 0.5 and direction.x > -0.5  and direction.y < 0:
		#O player está acima e a direita do enemy (topdown)
		texture_sprite.frame_coords = Vector2i(0, 0)
		texture_sprite.flip_v = false
		texture_sprite.flip_h = false

	elif direction.x > -0.5 and direction.x < 0.5  and direction.y > 0:
		#O player está abaixo e a esquerda do enemy (topdown)
		texture_sprite.frame_coords = Vector2i(0, 0)
		texture_sprite.flip_v = true
		texture_sprite.flip_h = true
		
	elif direction.x > -0.5 and direction.x < 0.5  and direction.y > 0:
		#O player está abaixo e a direita do enemy (topdown)
		texture_sprite.frame_coords = Vector2i(0, 0)
		texture_sprite.flip_v = true
		texture_sprite.flip_h = false
		
	set_collision_shape()
	set_to_hit_collision_shape(texture_sprite.get_frame(), texture_sprite.flip_h, texture_sprite.flip_v)
	
func set_collision_shape() -> void:

	match texture_sprite.get_frame():
		0:
			collision_shape.set_shape(retangle_shape_vertical)
			collision_shape.position = Vector2(-0.5, 0)
		1:
			collision_shape.set_shape(retangle_shape_horizontal)
			collision_shape.position = Vector2(0, -1)
		2:
			collision_shape.set_shape(retangle_shape_horizontal)
			collision_shape.position = Vector2(0, 0)
			if texture_sprite.flip_h and not texture_sprite.flip_v:
				collision_shape.set_rotation_degrees(45.0)
			elif texture_sprite.flip_v and not texture_sprite.flip_h:
				collision_shape.set_rotation_degrees(45.0)
			elif texture_sprite.flip_h and texture_sprite.flip_v:
				collision_shape.set_rotation_degrees(-45.0)
			elif not texture_sprite.flip_h and not texture_sprite.flip_v:
				collision_shape.set_rotation_degrees(-45.0)
				
	

func set_to_hit_collision_shape(get_frame_texture:int, fliph: bool, flipv: bool) -> void:
	to_hit_collision.set_shape(to_hit_shape)
	match get_frame_texture:
		
		0:
			if flipv:
				to_hit_collision.position = Vector2(-0.5, 5)
				to_hit_collision.shape.size = Vector2(7, 6.5)
			elif not flipv:
				to_hit_collision.position = Vector2(-0.5, -5)
				to_hit_collision.shape.size = Vector2(7, 6.5)
				
		1:
			if fliph:
				to_hit_collision.position = Vector2(-5, -0.5)
				to_hit_collision.shape.size = Vector2(7, 7)
			elif not fliph:
				to_hit_collision.position = Vector2(5, -0.5)
				to_hit_collision.shape.size = Vector2(7, 7)
		
		2:
			if fliph and flipv:
				to_hit_collision.position = Vector2(-3, 4)
				to_hit_collision.shape.size = Vector2(7, 6.5)
			elif not fliph and not flipv:
				to_hit_collision.position = Vector2(3, -4)
				to_hit_collision.shape.size = Vector2(7, 6.5)
			elif not fliph and flipv:
				to_hit_collision.position = Vector2(3, 4)
				to_hit_collision.shape.size = Vector2(7, 6.5)
			elif fliph and not flipv:
				to_hit_collision.position = Vector2(-3, -4)
				to_hit_collision.shape.size = Vector2(7, 6.5)

func on_to_hit_area_body_entered(body) -> void:
	if body.get_class() == 'TileMap':
		animation.play('kill')
	elif body.get_class() == 'CharacterBody2D' and body.name.contains('Player'):
		self.call_deferred('set_freeze_enabled', true)
		get_tree().call_group('stats', 'update_health', 'decrease', base_attack)
		animation.play('kill')


func on_animation_finished(anim_name: String) -> void:
	match anim_name:
		'kill':
			queue_free()


func on_life_timer_arrow_timeout() -> void:
	queue_free()
