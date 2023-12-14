extends Node2D

@export var bonus_bar: TextureProgressBar

func set_progress_bar(max_time: float) -> void:
	bonus_bar.max_value = max_time
	bonus_bar.value = max_time
	
func update_bonus_bar(actual_time: float) -> void:
	bonus_bar.value = actual_time
