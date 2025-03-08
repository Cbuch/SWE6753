extends ProjectileBase

@export var start_pos: Vector2
@export var end_pos: Vector2
@export var base_speed: float = 400.0  # Renamed from speed
@export var deceleration_range: float = 50.0  # Increased range
@export var base_size: float = .35

#stuff for flipping and such
var going_up = true
var flipped = false
var moving_to_end: bool = true

func _ready():
	if start_pos == Vector2.ZERO:
		start_pos = position  # Default start position
	if end_pos == Vector2.ZERO:
		end_pos = start_pos + Vector2(300, 0)  # Moves 300 pixels right

func _process(delta):
	var target = end_pos if moving_to_end else start_pos
	var direction = (target - position).normalized()
	
	var distance = position.distance_to(target)

	# Slow down near the end
	var current_speed = base_speed
	if distance < deceleration_range:
		current_speed = lerp(0.1, base_speed, distance / deceleration_range)
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
