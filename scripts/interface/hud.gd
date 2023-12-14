extends CanvasLayer

class_name Hud


@export var exp_bar: TextureProgressBar
@export var score_text: Label
@export var level_text: Label

var actual_score: int

func set_exp_bar(current_exp: int, max_exp:int) -> void:
	exp_bar.value = current_exp
	exp_bar.min_value = 0
	exp_bar.max_value = max_exp
	
	

func call_tween(type:String, value:int) -> void:
	match type:
		'exp':
			var tween: Tween = create_tween()
			tween.tween_property(
				exp_bar,
				'value',
				value,
				0.2
				).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
				

func set_level_text(level: int) -> void:
	level_text.text = str(level)
	get_tree().call_group('enemy_spawner', 'get_level', level)
	
	
func update_score_text(score:int) -> void:
	actual_score = int(score_text.get_text()) + score
	score_text.text = str(actual_score)
	


