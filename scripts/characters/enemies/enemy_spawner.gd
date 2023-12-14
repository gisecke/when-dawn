extends Marker2D

class_name EnemySpawner

@export var enemies:Dictionary

@onready var spawn_timer:Timer = get_node("SpawnTimer")

var player:CharacterBody2D
var level:int
var offset_position:Vector2
var rng: int

func _ready():
	player = Global.player
	
func get_level(actual_level:int) -> void:
	level = actual_level
	
func calculate_spawn() -> void:
	rng = randi() % 100
	if level > -1 and level < 3:
		spawn_enemy('Bat')
	#2ª Condição
	elif level >=3 and level < 6:
		if rng < 50:
			spawn_enemy('Bat')
		else:
			spawn_enemy('Wolf')
	#3º
	elif level >= 6 and level < 9:
		if rng < 33:
			spawn_enemy('Bat')
		elif rng >= 33 and rng <= 66:
			spawn_enemy('Wolf')
		else:
			spawn_enemy('Bone Skeleton')
#	4º
	elif level >= 9 and level < 12:
		if rng < 25:
			spawn_enemy('Bat')
		elif rng >= 25  and rng < 50:
			spawn_enemy('Wolf')
		elif rng >= 50  and rng < 75:
			spawn_enemy('Bone Skeleton')
		else:
			spawn_enemy('Archer Skeleton')
					
	else:
		if rng < 20:
			spawn_enemy('Bat')
		elif rng >= 20  and rng < 40:
			spawn_enemy('Wolf')
		elif rng >= 40  and rng < 60:
			spawn_enemy('Bone Skeleton')
		elif rng >= 60  and rng < 80:
			spawn_enemy('Archer Skeleton')
		else:
			spawn_enemy('Necromance')



func spawn_enemy(enemy: String) -> void:
	var enemy_path = load(enemies[enemy])
	var enemy_body = enemy_path.instantiate()
	get_parent().call_deferred("add_child", enemy_body)
	enemy_body.global_position = global_position


func on_spawn_timer_timeout():
	var sinal_x: int = sign(randi_range(-10, 10))
	var sinal_y: int = sign(randi_range(-10, 10))
	offset_position = Vector2(
		randf_range(get_viewport_rect().size.x, get_viewport_rect().size.x + 70)*sinal_x,
		randf_range(get_viewport_rect().size.y, get_viewport_rect().size.y + 70)*sinal_y
		)
	global_position = player.global_position + offset_position
	
	calculate_spawn()
	
func pause_timer(pause_condition:bool) -> void:
	if pause_condition:
		spawn_timer.stop()
	else:
		spawn_timer.start()
		
			
