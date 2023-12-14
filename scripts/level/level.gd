extends Node2D

class_name Level

signal escape_pressed

@export var hud: CanvasLayer
@export var music_node: AudioSfx
@export var scene_path:String
@export var pause_menu_path:PackedScene
var enemy_spawner:Marker2D

var player_path:String
var player:CharacterBody2D
var is_paused: bool = false
var pause_menu: CanvasLayer

func _ready():
	randomize()
	Global.level = self
	DataManagement.load_data()
	player_path = DataManagement.data_dictionary.player_selected
	player = load(player_path).instantiate()
	call_deferred('add_child', player)
	call_deferred('move_child', player, hud.get_index())
	
	enemy_spawner = load("res://scenes/enemies/enemy_spawner.tscn").instantiate()
	call_deferred("add_child", enemy_spawner)
	call_deferred('move_child', enemy_spawner,hud.get_index())
	
	var texture_player:Sprite2D = player.get_node('Texture')
	texture_player.connect('game_over', Callable(self, 'on_game_over'))
	transition_screen.visible = true
	transition_screen.swipe_out()
	

func _process(_delta) -> void:
		menu_behavior()
	
func menu_behavior() -> void:
	if Input.is_action_just_pressed('esc'):
		emit_signal('escape_pressed')
	
	
		
func on_game_over() -> void:
	DataManagement.data_dictionary.reload += 1
	DataManagement.save_data()
	transition_screen.mask_rect.visible = true
	transition_screen.scene_path = scene_path
	transition_screen.fade_in()


func on_music_finished() -> void:
	music_node.play_audio("res://assets/sounds/music/theme_forest.ogg")


func on_escape_pressed():
	is_paused = not is_paused
	if is_paused:
		Global.player.set_physics_process(false)
		for e in Global.enemy.size():
			Global.enemy[e].set_physics_process(false)
		get_tree().call_group('spawn_timer', 'pause_timer', true)
		get_tree().call_group('animation', 'pause_animation', true)
		pause_menu = pause_menu_path.instantiate()
		call_deferred("add_child", pause_menu)
		
	
		
