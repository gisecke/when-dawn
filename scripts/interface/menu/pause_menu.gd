extends CanvasLayer

@export var audio_sfx:AudioSfx
@onready var animation:AnimationPlayer = get_node('Animation')
signal escape_pressed

func _ready() -> void:
	for button in get_tree().get_nodes_in_group('button'):
		button.connect('mouse_entered',Callable(self, 'on_mouse_entered'))
		button.connect('pressed', Callable(self, 'on_button_pressed').bind(button.name))
		
func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		emit_signal('escape_pressed')

func on_mouse_entered() -> void:
	audio_sfx.play_audio("res://assets/sounds/interface/Wood Hit Single.ogg")
	
func on_button_pressed(button_name:String) -> void:
	audio_sfx.play_audio("res://assets/sounds/interface/Clicked.ogg")
	match button_name:
		'BackButton':
			_on_escape_pressed()
		'SaveButton':
			for s in get_tree().get_nodes_in_group('slider'):
				s.save_data()
			exit_menu()
	
func on_sfx_value_changed() -> void:
	audio_sfx.play_audio("res://assets/sounds/interface/Wood Hit Single.ogg")


func _on_escape_pressed() -> void:
	get_tree().call_group("slider", 'load_data')
	exit_menu()
	
func exit_menu() -> void:
	animation.play('out')

func _on_animation_finished(anim_name):
	match anim_name:
		'out':
			Global.player.set_physics_process(true)
			for e in Global.enemy.size():
				Global.enemy[e].set_physics_process(true)
			get_tree().call_group('spawn_timer', 'pause_timer', false)
			get_tree().call_group('animation', 'pause_animation', false)
			queue_free()
