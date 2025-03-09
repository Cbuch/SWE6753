extends Control

func _ready() -> void:
	$VBoxContainer/Goback.grab_focus()  

func _on_go_back_pressed() -> void:
	print("Back to Main Menu pressed")  
	get_tree().change_scene_to_file("res://Menus/MenuScenes/MainMenu.tscn")  # Ensure the path is correct
