extends Camera2D

class_name CameraPlayer

@export var timer:Timer

var shake_amount: float = 0
var default_offset: Vector2 = Vector2.ZERO


func _ready() -> void:
	set_process(false)
	Global.camera = self
	timer.wait_time  = 0.4
	
	
func _process(_delta) -> void:
	offset = Vector2(
		randf_range(-shake_amount, shake_amount),
		randf_range(shake_amount, -shake_amount)
	)
	
func shake_camera(new_shake, shake_limit:float = 100.0) -> void:
	set_process(true)
	shake_amount += new_shake
	
	if shake_amount > shake_limit:
		shake_amount = shake_limit
	
	timer.start()


func on_timer_timeout() -> void:
	set_process(false)
	shake_amount = 0
	var tween:Tween = create_tween()
	tween.tween_property(
		self,
		'offset',
		default_offset,
		0.1
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
