extends HSlider

@export var audiobusname = "Master"

@onready var _bus = AudioServer.get_bus_index(audiobusname)
var config = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load data from a file.
	var confLoad = config.load("res://configs/volume.cfg")

	# If the file didn't load, set volume to 100%
	if confLoad != OK:
		value = db_to_linear(AudioServer.get_bus_volume_db(_bus))
		print(value)
	else:
		value = config.get_value("Volume", "LastVolume")
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))



func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))
	
	config.set_value("Volume", "LastVolume", value)
	config.save("res://configs/volume.cfg")
	print (value)
	release_focus()
