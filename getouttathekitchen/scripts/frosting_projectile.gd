extends CharacterBody2D  # Or Area2D if using collisions

@export var speed: float = 600.0  # Pixels per second
var damage = 25
func _process(delta):
	position.y += speed * delta
	move_and_slide()
