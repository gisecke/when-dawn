extends Control

class_name InitialScreen

@export var animation:AnimationPlayer
@export var start_screen:Control
@export var audio_sfx:AudioSfx
@export var audio_music:AudioSfx
@export var option_box:VBoxContainer
@export var select_player_container:VBoxContainer

var scene_path:String = "res://scenes/level/level.tscn"
var current_state: int
enum StateButton {PLAY, OPTION, QUIT, SAVE, BACK, SELECT}

func _ready() -> void:
	
	call_tween(audio_music, 'volume_db', linear_to_db(1), 2.0)
	
	transition_screen.visible = false
	for button in get_tree().get_nodes_in_group('button'):
		var callable = Callable(self, 'on_button_pressed')
		button.connect(
			'mouse_entered',
			Callable(self, 'on_mouse_entered')
			)
		button.connect(
			'pressed',
			callable.bind(button.name))
			


func on_button_pressed(button_name:String) -> void:
	audio_sfx.play_audio("res://assets/sounds/interface/Clicked.ogg")
	match  button_name:
		'QuitButton':
			animation.play('fade_in')
			current_state = StateButton.QUIT
			
		'Barbarian':
			selected_player(button_name)
			
		'Knight':
			selected_player(button_name)
			
		'Wizard':
			selected_player(button_name)
			
		'StartButton':
			animation.play('fade_in')
			current_state = StateButton.SELECT
			
		'OptionButton':
			animation.play('fade_in')
			current_state = StateButton.OPTION
			
		'BackButton':
			animation.play('fade_in')
			current_state = StateButton.BACK
			
		'SaveButton':
			get_tree().call_group('slider', 'save_data')
			animation.play('fade_in')
			current_state = StateButton.SAVE
			
func on_mouse_entered() -> void:
	audio_sfx.play_audio("res://assets/sounds/interface/Wood Hit Single.ogg")

func on_animation_finished(anim_name):
	match anim_name:
		'fade_in':
			match current_state:
				StateButton.QUIT:
					get_tree().quit()
					
				StateButton.SELECT:
					animation.play('fade_out')
					start_screen.visible = false
					select_player_container.visible = true
					
				StateButton.PLAY:
					DataManagement.save_data()
					animation.play('fade_out')
					get_tree().change_scene_to_file(scene_path)
					
				StateButton.OPTION:
					animation.play('fade_out')
					start_screen.visible = false
					option_box.visible = true
					
				StateButton.BACK:
					animation.play('fade_out')
					get_tree().call_group("slider", 'load_data')
					start_screen.visible = true
					option_box.visible = false
					select_player_container.visible = false
					
				StateButton.SAVE:
					animation.play('fade_out')
					start_screen.visible = true
					option_box.visible = false


func call_tween(obj:Object, property:String, value:Variant, duration:float) -> void:
	var tween:Tween = create_tween()
	tween.tween_property(
		obj,
		property,
		value,
		duration
	).set_trans(Tween.TRANS_LINEAR)

func on_sfx_value_changed() -> void:
	audio_sfx.play_audio("res://assets/sounds/interface/Wood Hit Single.ogg")
	
func selected_player(button_name:String) -> void:
	call_tween(audio_music, 'volume_db', linear_to_db(0.1), 1.0)
	animation.play('fade_in')
	match button_name:
		'Barbarian':
			DataManagement.data_dictionary.player_selected = "res://scenes/heros/barbarian_player.tscn"
		'Knight':
			DataManagement.data_dictionary.player_selected = "res://scenes/heros/knight_player.tscn"
		'Wizard':
			DataManagement.data_dictionary.player_selected = "res://scenes/heros/Wizard/wizard_player.tscn"
	current_state = StateButton.PLAY
