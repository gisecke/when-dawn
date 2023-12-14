extends CanvasLayer

@export var animation:AnimationPlayer
@onready var mask_rect: ColorRect = get_node("MaskRect")

var scene_path: String

func fade_in() -> void:
	animation.play('fade_in')
	
func swipe_out() -> void:
	animation.play('swipe_out')
	


func on_animation_finished(anim_name:String) -> void:
	match anim_name:
		'fade_in':
			
			var _change_scene = get_tree().change_scene_to_file(scene_path)
			mask_rect.visible = false
			
