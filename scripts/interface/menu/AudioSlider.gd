extends HSlider


@export var bus_name:String

@onready var bus_index:int

func _ready() -> void:
	
	bus_index = AudioServer.get_bus_index(bus_name)
	load_data()

func _on_value_changed(value_data:float):
	
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value_data)
	)

	#Emite um som 'sfx' para percepção do volume do mesmo
	if AudioServer.get_bus_name(bus_index) == 'Sfx':
		get_tree().call_group('pause_menu', 'on_sfx_value_changed')
		get_tree().call_group('initial_screen', 'on_sfx_value_changed')
		
		
func save_data() -> void:
	match bus_name:
		'Master':
			DataManagement.data_dictionary.master_volume = value
		'Music':
			DataManagement.data_dictionary.music_volume = value
		'Sfx':
			DataManagement.data_dictionary.sfx_volume = value
	DataManagement.save_data()

func load_data() -> void:
	DataManagement.load_data()
	match bus_name:
		'Master':
			value = DataManagement.data_dictionary.master_volume
		'Music':
			value = DataManagement.data_dictionary.music_volume
		'Sfx':
			value = DataManagement.data_dictionary.sfx_volume
