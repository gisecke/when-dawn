extends CharacterBody2D

class_name PlayerTemplate


@onready var player_texture:Sprite2D = get_node("Texture")
@onready var stats: Node2D = get_node("Stats")
@export var max_speed: int

@export var walking_audio_sfx: AudioStreamPlayer
@export var action_audio_sfx:AudioStreamPlayer

var direction: Vector2
var attacking: bool = false
var on_hit: bool = false
var dead: bool = false
var can_track_input: bool = true
var local_position: Vector2i
var walking_audio: AudioStream



func _enter_tree():
	Global.player = self

	

func _physics_process(_delta):
	move_behavior()
	action_behavior()
	
func move_behavior() -> void:
	if attacking: #se estiver atacando ele tem que parar
		velocity = Vector2(0,0)

	direction = Input.get_vector("left", 'right', 'up', 'down')
	move_and_slide()
	player_texture.animate(direction)

	velocity = direction * max_speed
	local_position = Global.tile_map.local_to_map(position)
	
	if direction != Vector2.ZERO and not walking_audio_sfx.is_playing():
		play_audio_walk()

	elif direction == Vector2.ZERO:
		walking_audio_sfx.stop()
		

func action_behavior() -> void:
	pass

func play_audio_walk() -> void:

	#checar se está na areia
	if Global.tile_map.sand_positions.find(local_position) > -1:
		walking_audio_sfx.play_audio('res://assets/sounds/walking/walking_on_sand.ogg')
		
	#checar se está na stone
	elif Global.tile_map.stone_positions.find(local_position) > -1:
		walking_audio_sfx.play_audio("res://assets/sounds/walking/walking_on_stone.wav")
		
	else:
		walking_audio_sfx.play_audio("res://assets/sounds/walking/walking_on_grass.ogg")

func play_action_audio(path:String) -> void:
	action_audio_sfx.stream = load(path)
	action_audio_sfx.play()

	


func _on_damage_area_entered(_area):
	pass # Replace with function body.



