extends Label

class_name FloatingText

@export var damage_color:Color
@export var exp_color:Color
@export var heal_color: Color
@export var offset_x:float

var type: String
var value: int
var position_x: float
var position_y: float

func _ready():

	if Global.player != null and Global.player.get_node('Texture').suffix == '_left':
		offset_x = -offset_x
	
	spawn_text()
	
func spawn_text() -> void:
	text = str(value)
	global_position.y = position_y
	global_position.x = position_x
	match type:
		'heal':
			modulate = heal_color
		'damage':
			modulate = damage_color
		'exp':
			modulate = exp_color
	
	interpolate()
	
func interpolate() -> void:
	var position_tween: Tween = get_tree().create_tween()
	position_tween.parallel().tween_property(
		self,
		'position',
		Vector2((position_x + offset_x), position_y),
		0.5
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	var tween:Tween = create_tween()
	tween.tween_property(
		self,
		'scale',
		Vector2(1, 1),
		0.5
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(
		self,
		'scale',
		Vector2(0.01, 0.01),
		0.8
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	self.queue_free()
	
