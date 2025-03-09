extends Control

var paused = false

func _ready() -> void:
	pass  # Replace with function body if needed

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Press ESC to toggle pause
		_toggle_pause()

func _toggle_pause() -> void:
	print("Toggling pause. Current state:", paused)
	paused = !paused
	get_tree().paused = paused
	visible = paused  

func _on_resume_pressed() -> void:
	print("Resume pressed")
	get_tree().paused = false 
	visible = false

func _on_quit_to_main_menu_pressed() -> void:
	print("Quit to Main Menu pressed")
	get_tree().paused = false  
	get_tree().change_scene_to_file("res://Menus/MenuScenes/MainMenu.tscn") 
