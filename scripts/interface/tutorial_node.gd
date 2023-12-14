extends Node2D

class_name TutorialNode

var reloads: int

func _ready():
	DataManagement.load_data()
	reloads = DataManagement.data_dictionary.reload
	if reloads >0:
		self.queue_free()

func _on_timer_timeout():
	self.queue_free()
