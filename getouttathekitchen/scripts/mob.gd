extends CharacterBody2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target: CharacterBody2D

const SPEED = 415

func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()

func _process(delta: float) -> void:
	navigation_agent.target_position = target.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position())
	move_and_slide()
	
