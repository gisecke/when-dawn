extends StaticBody2D

@export var animation:AnimationPlayer
@export var audio_sfx:AudioSfx

var is_interacted: bool = false
var is_open: bool = false
var count_entered:int = 0
var wheel_items_path:PackedScene = load("res://scenes/interface/wheel_items.tscn")

func _process(_delta) -> void:
	if Input.is_action_just_pressed("interact") and is_interacted and is_open and count_entered == 0:
		animation.play('open')
		count_entered += 1
		audio_sfx.play()
		

func on_touch_area_entered(_body: PlayerTemplate):
	is_interacted = true
	is_open = true
	
func play_kill_animation() ->void:
	animation.play('kill')


func on_animation_finished(anim_name):
	match anim_name:
		'open':
			is_open = false
			animation.pause()
			var wheel_item:CanvasLayer = wheel_items_path.instantiate()
			get_parent().call_deferred("add_child", wheel_item)
		
		'kill':
			kill_chest()
			
func kill_chest() -> void:
	queue_free()
