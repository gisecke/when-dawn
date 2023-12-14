extends Node


var save_path: String = 'user://save.dat'

var data_dictionary: Dictionary = {
	'master_volume': 1.0,
	'music_volume': 1.0,
	'sfx_volume': 1.0,
	'player_selected': '',
	'reload': 0
}


func save_data() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data_dictionary)
	file.close()

func load_data() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		data_dictionary = file.get_var()
		file.close()
