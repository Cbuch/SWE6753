extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Start.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

#Button Press Functions
func _on_start_pressed() -> void:
	print("Start button pressed") # Debug
	get_tree().change_scene_to_file("res://Scenes/base_level.tscn")
func _on_quit_pressed() -> void:
	get_tree().quit()
func _on_settings_pressed() -> void:
	print("Settings button pressed")
	get_tree().change_scene_to_file("res://Menus/MenuScenes/SettingsMenu.tscn")  
