extends CharacterBody2D

class_name EnemyTemplate


@export var attack_area: Area2D
@export var damage_area: Area2D
@export var texture: Sprite2D
@export var animation: AnimationPlayer
@export var stuck_timer: Timer
@export var detection_area: Area2D
@export var particles: GPUParticles2D
@export var health_bar: Node2D
@export var walking_sfx:AudioStreamPlayer2D
@export var floating_text:PackedScene


@export var speed: int
@export var base_attack:int
@export var enemy_health: int
@export var exp_drop: int
@export var score_drop:int



var player: CharacterBody2D
var direction: Vector2
var player_detection: bool = false
var attack: bool = false
var real_velocity:Vector2
var last_position_wall: Vector2
var enemy_type: String
var collided: bool = false
var last_speed: int
var attack_off: bool = false

var hit: bool = false
var dead: bool = false

var is_on_screen: bool = false

func _ready():
	Global.enemy.append(self)
	find_hero()
	last_speed = speed
	health_bar.set_health_bar(enemy_health, enemy_health)

	
func find_hero() -> void:
	player = Global.player
			
			
func _physics_process(_delta):
	move_behavior()
	stuck_behavior()
	flip_direction()
	texture.animate(velocity)
	
	move_and_slide()
	
func move_behavior() -> void:
	if player != null and not attack and not player_detection:
		direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		
		
		if is_on_screen and not walking_sfx.is_playing() and not dead and not attack:
			walking_sfx.play()
		elif not is_on_screen:
			walking_sfx.stop()
		
		if not stuck_timer.is_stopped(): #o inimigo colidiu com algo
			var position_reference: Vector2 = last_position_wall.direction_to(player.global_position)
			if (
				position_reference.x < 0
				and position_reference.y > 0
				): #significa que o player está abaixo e a esquerda do objeto
				velocity.y += speed/float(2)
				velocity.x += speed/float(2)
				
				
			elif (
				position_reference.x > 0
				and position_reference.y > 0
				): #significa que o player está abaixo e a direita do objeto
				velocity.y += speed/float(2)
				velocity.x += speed/float(2)
				
				
			elif (
				position_reference.x > 0
				and position_reference.y < 0
				): #significa que o player está acima e a direita do objeto
				velocity.y += speed/float(2)
				velocity.x += speed/float(2)
				
				
			elif (
				position_reference.x < 0
				and position_reference.y < 0
				): #significa que o player está acima e a esquerda do objeto
				velocity.y += speed/float(2)
				velocity.x -= speed/float(2)


func stuck_behavior() -> void:
	if is_on_wall() and not collided:
		if get_real_velocity() > Vector2(-2, -2) or get_real_velocity() < Vector2(2,2):
			collided = true
			stuck_timer.start()
			last_position_wall = get_last_slide_collision().get_position()
			
			
					
func flip_direction() -> void:
	if direction.x < 0:
		texture.flip_h = true
		
	else:
		texture.flip_h = false
		
			
func on_detection_area_entered(_body: PlayerTemplate) -> void:
	player_detection = true
	attack = true
	attack_off = true

func on_detection_area_exited(_body: PlayerTemplate) -> void:
	player_detection = false


func on_stuck_timer_timeout()-> void:
	collided = false


func on_damage_area_entered(area: Area2D) -> void:
	if area.get_parent().get_class() == "Marker2D" or area.get_parent().name.contains('Player') and area.name == 'AttackArea':
		var player_stats: Node = area.get_parent().get_node('Stats')
		var player_attack: int = player_stats.base_attack
		update_enemy_health(player_attack)
		spawn_floating_text('damage', player_attack)
		
		
		


func update_enemy_health(value: int) -> void:
	enemy_health -= value
	health_bar.call_tween(enemy_health)
	if enemy_health <= 0:
		dead = true
	else:
		hit = true
	

func kill_enemy() -> void:
	Global.enemy.erase(self)
	animation.play('kill')
	spawn_drop()
	get_tree().call_group('hud', 'update_score_text', score_drop)
	
func spawn_drop() -> void:
	var exp_load = load("res://scenes/itens/xp_item.tscn")
	var drops:Array = []
	drops.resize(exp_drop)
	for i in drops:
		var exp_body:RigidBody2D = exp_load.instantiate()
		Global.level.call_deferred("add_child", exp_body)
		var spawn_position: Vector2 = Vector2(0 , 0)
		spawn_position.x = randi() % 21
		spawn_position.y = randi() % 21
		exp_body.global_position = global_position + spawn_position

		


func _on_attack_area_body_entered(body: PlayerTemplate):
	if body.get_class() == 'CharacterBody2D' and attack:
		get_tree().call_group('stats', 'update_health', 'decrease', base_attack)



func on_visible_screen_notifier():
	is_on_screen = true


func on_visible_screen_exited():
	is_on_screen = false


func spawn_floating_text(type:String, value:int) -> void:
	var text: FloatingText = floating_text.instantiate()
	text.type = type
	text.value = value
	Global.level.call_deferred('add_child', text)
	text.position_x = global_position.x
	text.position_y = global_position.y
