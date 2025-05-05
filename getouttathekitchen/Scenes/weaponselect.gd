extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_knifebutton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/base_level_knives.tscn")


func _on_tenderbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/base_level_tender.tscn")


func _on_orbbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/base_level_orb.tscn")
