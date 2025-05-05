extends Node2D  # Or Area2D if using collisions

@export var speed: float = 200.0  # Pixels per second

func _process(delta):
	position.y += speed * delta
