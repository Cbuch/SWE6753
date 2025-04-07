extends Control

func _ready() -> void:
	$VBoxContainer/Goback.grab_focus()
	_load_volume_setting()

func _on_go_back_pressed() -> void:
	print("Back to Main Menu pressed")
	get_tree().change_scene_to_file("res://Menus/MenuScenes/MainMenu.tscn")

func _on_volume_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, value)
	_save_volume_setting(value)

func _save_volume_setting(value: float) -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", value)
	config.save("user://settings.cfg")

func _load_volume_setting() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		var volume = config.get_value("audio", "master_volume", 0)
		$VBoxContainer/VolumeSlider.value = volume
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
