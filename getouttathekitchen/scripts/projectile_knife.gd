extends ProjectileBase

@export var start_pos: Vector2
@export var end_pos: Vector2
@export var deceleration_range: float = 50.0  # Increased range


#Not sure what happened here, but I'm hardcoding damage for now
#var player_scene = load("res://Scenes/player.tscn")
#var player_instance = player_scene.instantiate()
#var player = player_instance.get_node("Player")
var weapondamage = 50

#stuff for flipping and such
var going_up = true
var flipped = false
var moving_to_end: bool = true

func _ready():
	if start_pos == Vector2.ZERO:
		start_pos = position  # Default start position
	if end_pos == Vector2.ZERO:
		end_pos = start_pos + Vector2(150, 0)  # Moves 400 pixels right

func _process(delta):
	var target = end_pos if moving_to_end else start_pos
	var direction = (target - position).normalized()
	
	var distance = position.distance_to(target)

	# Slow down near the end
	var current_speed = speed
	if distance < deceleration_range:
		current_speed = lerp(0.1, speed, distance / deceleration_range)
		if (!$AnimationPlayer.is_playing() && !flipped):
			if(going_up):
				$AnimationPlayer.play("Knife_flip_down")
			else:
				$AnimationPlayer.play("Knife_flip_up")
			flipped = true
			going_up = !going_up

	position += direction * current_speed * delta

	# Reverse direction when reaching the destination
	if distance < 1.0:  # Increased threshold for better behavior
		moving_to_end = !moving_to_end
		flipped = false
		#if(going_up):
			#$AnimationPlayer.play("Knife_flip_down")
		#else:
			#$AnimationPlayer.play("Knife_flip_up")
		#going_up = !going_up


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
