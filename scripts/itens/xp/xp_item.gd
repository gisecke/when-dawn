extends RigidBody2D

class_name exp_crystal

@export var force:Vector2

@export var animation: AnimationPlayer
@export var audio_sfx:AudioSfx

var initial_position:Vector2
var last_position_offset:Vector2
var value_xp: int = 1


var player: PlayerTemplate

var is_catching: bool = false

func _ready():
	initial_position = global_position
	linear_velocity = Vector2(0, -10)
	animation.play('idle')
	
	animation.animation_finished.connect(on_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	last_position_offset = global_position - initial_position
	if not is_catching:
		if last_position_offset.y < 0 and last_position_offset.y <= -2:
			linear_velocity = Vector2(0, 5)
		elif last_position_offset.y > 0 and last_position_offset.y >= 2:
			linear_velocity = Vector2(0, -5)
			
	elif is_catching:
		var direction: Vector2 =  player.global_position - global_position
		set_axis_velocity(direction)


func on_catch_area_entered(body: PlayerTemplate):
		is_catching = true
		player = body
		


func on_touch_area_entered(body: PlayerTemplate):
	if body != null:
		animation.play('explosion')
		self.call_deferred('set_freeze_enabled', true)
		get_tree().call_group('stats', 'update_exp', value_xp)
		audio_sfx.play()
		
		
func on_animation_finished(anim_name:String):
	match anim_name:
		'explosion':
			queue_free()
