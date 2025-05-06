extends Control

var config = ConfigFile.new()
var thisbool = true
func _ready() -> void:
	$HSlider.grab_focus()
	# Load data from a file.
	var confLoad = config.load("res://configs/squash.cfg")
	if confLoad != OK:
		$HSlider.value = 1

func _process(delta: float) -> void:
	if (thisbool == true) :
		$HSlider.value = config.get_value("Volume", "LastVolume")
		thisbool = false

func _on_go_back_pressed() -> void:
	print("Back to Main Menu pressed")
	get_tree().change_scene_to_file("res://Menus/MenuScenes/MainMenu.tscn")


func _on_h_slider_value_changed(value: float) -> void:
	config.set_value("Volume", "LastVolume", value)
	config.save("res://configs/squash.cfg")
	Settings.sfx_volume = $HSlider.value
	Settings.save_settings()
