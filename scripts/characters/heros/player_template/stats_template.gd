extends Node2D

class_name PlayerStats

@export var timer_bonus:Timer
@export var player: CharacterBody2D
@export var animation_player: AnimationPlayer
@export var health_bar: Node2D
@export var bonus_timer_bar: Node2D

@export var max_health: int
@export var base_attack: int

@export var offset: float

var spawn_meteor_packed: PackedScene = load("res://scenes/itens/meteor/spawn_meteor.tscn")
var floating_text:PackedScene = load("res://scenes/interface/floating_text.tscn")

var bonus_velocity:int
var bonus_health: int = 0
var bonus_attack: float = 1.0
var bonus_attack_velocity: float = 1.0
var bonux_xp_multiply: float = 1.0

var current_health: int

var current_exp: int = 0
var max_exp: int = 70

var level: int = 1



var enemy: CharacterBody2D


func _ready() -> void:
	current_health = max_health
	get_tree().call_group('hud', 'set_exp_bar', current_exp, max_exp)
	get_tree().call_group('hud', 'set_level_text', level)
	health_bar.set_health_bar(current_health, max_health)
	base_attack = roundi(base_attack * bonus_attack)
	
	
func bonus_improvment(type: String, value: float, permanent_effect:bool) -> void:
	match type:
		'life':
			max_health = roundi(value * max_health)
			current_health = max_health
			health_bar.call_tween(current_health)
		'xp':
			bonux_xp_multiply = value
				
		'velocity attack':
			bonus_attack_velocity = value
		'attack':
			bonus_attack = value
			base_attack = roundi(base_attack * bonus_attack)
				
	if !permanent_effect:
		bonus_timer_bar.set_progress_bar(timer_bonus.get_wait_time())
		timer_bonus.start()
				

func _process(_delta) -> void:
	if timer_bonus.time_left != 0:
		bonus_timer_bar.update_bonus_bar(timer_bonus.time_left)

func update_health(type: String, value:int) -> void:
	match type:
		'increase':
			current_health += value
			if current_health >= max_health:
				current_health = max_health
				health_bar.call_tween(current_health)
				spawn_floating_text('heal', value)
				
				
		'decrease':
			current_health -= value
			if current_health <= 0:
				player.dead = true
				health_bar.call_tween(current_health)
			else:
				player.on_hit = true
				player.attacking = false
				health_bar.call_tween(current_health)
				
			spawn_floating_text('damage', value)


func update_exp(exp_value: int) -> void:
	
	current_exp += int(exp_value * bonux_xp_multiply)
	get_tree().call_group('hud', 'call_tween', 'exp', current_exp)
	spawn_floating_text('exp', exp_value)
	if current_exp >= max_exp:
		level += 1
		var lefttover: int = current_exp - max_exp
		current_exp = lefttover
		calculate_next_level(level)
		current_health = max_health
		
		#Call Groups
		get_tree().call_group('hud', 'set_exp_bar', current_exp, max_exp)
		get_tree().call_group('hud', 'set_level_text', level)
		spawn_meteor_function()
		


func calculate_next_level(actual_level:int) -> void:
	max_exp = int(pow(1.1, actual_level)*70)
	max_health = int(pow(1.2, actual_level)+max_health)
	base_attack = int(pow(1.2, actual_level)+base_attack)

func spawn_meteor_function() -> void:
	var spawn_meteor: Marker2D = spawn_meteor_packed.instantiate()
	Global.level.call_deferred('add_child', spawn_meteor)
	var offset_position_meteor = Vector2(
		randf_range(offset, -offset),
		randf_range(-offset, offset)
	)
	spawn_meteor.global_position = global_position + offset_position_meteor


func on_timer_bonus_timeout():
	bonus_timer_bar.update_bonus_bar(0.0)
	bonus_attack_velocity = 1.0
	bonux_xp_multiply = 1.0
	bonus_attack = 1.0
	
func spawn_floating_text(type:String, value:int) -> void:
	var text: FloatingText = floating_text.instantiate()
	text.type = type
	text.value = value
	Global.level.call_deferred('add_child', text)
	text.position_x = player.global_position.x
	text.position_y = player.global_position.y
	
