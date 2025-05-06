extends Node

var config_path := "user://settings.cfg"
var sfx_volume: float = 0.5

func _ready() -> void:
	load_settings()

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save(config_path)

func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(config_path)
	if err == OK:
		sfx_volume = config.get_value("audio", "sfx_volume", 0.5)
