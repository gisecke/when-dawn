extends AudioStreamPlayer

class_name AudioSfx
var bus_name:String


func play_audio(path:String, position:float = 0.0) -> void:
	self.stream = load(path)
	self.play(position)
