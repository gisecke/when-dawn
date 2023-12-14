extends GPUParticles2D

var player:CharacterBody2D
var delay_time: float
var duration_time: float
var windy:float


@export var spawn_timer:Timer
@export var min_spawn_time:float
@export var max_spawn_time:float
@export var delay_timer:Timer
@export var min_delay_time:float
@export var max_delay_time:float
@export var audio_sfx:AudioStreamPlayer

func _ready():
	delay_time = randf_range(min_delay_time, max_delay_time)
	duration_time = randf_range(min_spawn_time, max_spawn_time)
	delay_timer.start(delay_time)
	
	
	

func _process(_delta):
	if player != null: 
		global_position.x = player.global_position.x
		global_position.y  = player.global_position.y - (get_viewport_rect().size.y/2)

func on_spawn_timer_timeout() -> void:

	delay_time = randf_range(min_delay_time, max_delay_time)
	self.emitting = false
	delay_timer.start(delay_time)
	fade_in_out(-50.0)
	


func on_delay_timer_timeout() -> void:
	player = Global.player
	windy = randi_range(15, 50)
	get_process_material().set_gravity(Vector3(windy, 98, 0))
	spawn_timer.start(duration_time)
	self.emitting = true
	audio_sfx.play_audio("res://assets/sounds/enviorement/rain_loop.ogg")
	fade_in_out(0.0)
	
func fade_in_out(value) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(
		audio_sfx,
		'volume_db',
		value,
		1.0
		)


