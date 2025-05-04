extends Area2D

var type: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_groups():
		match i:
			"carb":
				type = i
				modulate = Color.YELLOW
			"meat":
				type = i
				modulate = Color.RED
			"dairy":
				type = i
				modulate = Color.STEEL_BLUE
			"sugar":
				type = i
				modulate = Color.HOT_PINK
			"veg":
				type = i
				modulate = Color.WEB_GREEN
			"fruit":
				type = i
				modulate = Color.REBECCA_PURPLE

func _on_area_entered(_area: Area2D) -> void:
	get_parent().crumbGrab(type)
	queue_free()
