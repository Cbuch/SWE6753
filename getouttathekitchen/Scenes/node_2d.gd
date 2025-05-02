extends Node2D

@export var pause = "pause"

func pauseHandler():
	var tree = get_tree()
	tree.paused = !tree.paused
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(pause):
		pauseHandler()
