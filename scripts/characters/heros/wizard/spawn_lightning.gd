extends Marker2D


func on_animation_finished(anim_name:String) -> void:
	match anim_name:
		'lightning':
			self.queue_free()
