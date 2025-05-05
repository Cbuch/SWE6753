extends CharacterBody2D  # Or Area2D if using collisions

@export var speed: float = 600.0  # Pixels per second
var damage = 25
var x_hold = 0
func _process(delta):
	velocity =Vector2(0,speed)
	#position.y += speed * delta
	position.x = x_hold
	move_and_slide()
