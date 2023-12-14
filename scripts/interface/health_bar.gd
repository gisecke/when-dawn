extends Node2D

@export var health_texture: TextureRect
@export var health_progress: TextureProgressBar




func set_health_bar(current_health:int, max_health: int) -> void:
	health_progress.max_value = max_health
	health_progress.value = current_health
	

func call_tween(value:int) -> void:
	var tween:Tween = create_tween()
	tween.tween_property(
		health_progress,
		'value',
		value,
		0.2
		).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	modulate_progresse(value)
	
func modulate_progresse(value: int) -> void:
	var percent: float = value / health_progress.max_value
	if percent <= 0.2:
		modulate = Color(0.6 ,0.6 , 0.6, 1)
	if percent > 0.2 and percent <= 0.4:
		modulate = Color(0.7 ,0.7 , 0.7, 1)
	if percent > 0.4 and percent <= 0.6:
		modulate = Color(0.8, 0.8 , 0.8, 1)
	if percent > 0.6 and percent <= 0.8:
		modulate = Color(0.9 ,0.9 , 0.9, 1)
	if percent > 0.8 and percent <= 1.0:
		modulate = Color(1.0 ,1.0 , 1.0, 1)
	
