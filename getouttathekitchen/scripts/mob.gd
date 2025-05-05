extends CharacterBody2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target: CharacterBody2D
@export var health = 100

var typing = "blank"
const SPEED = 300

@export var crumb: PackedScene

var damage = 25


func _ready():
	healthbar_setup()
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	print(typing)
	if (typing.contains("carb") || typing.contains("veg") || typing.contains("sugar") || typing.contains("meat") || typing.contains("fruit") || typing.contains("dairy")):
		animtype(typing)
		add_to_group(typing)
	else:
		$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()

func _process(delta: float) -> void:
	health_update()
	navigation_agent.target_position = target.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position())
	velocity *= SPEED

	move_and_slide()

func die():
	get_parent().lowerMobCount()
	dropCrumb()
	queue_free()

func _on_collision_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		health = health - area.get_parent().weapondamage
		health_update()
		if health <= 0:
			die()

func animtype(input: StringName):
	print(input)
	typing = input
	$AnimatedSprite2D.set_animation(input)

func healthbar_setup():
	$HealthBar.max_value = health
	
func health_update():
	$HealthBar.value=health

func dropCrumb():
	var newCrumb = crumb.instantiate()
	newCrumb.add_to_group($AnimatedSprite2D.animation)
	for i in newCrumb.get_groups():
		match i:
			"carb":
				newCrumb.modulate = Color.YELLOW
			"protein":
				newCrumb.modulate = Color.RED
			"dairy":
				newCrumb.modulate = Color.STEEL_BLUE
			"sugar":
				newCrumb.modulate = Color.HOT_PINK
			"veg":
				newCrumb.modulate = Color.WEB_GREEN
			"fruit":
				newCrumb.modulate = Color.REBECCA_PURPLE
	newCrumb.position = global_position
	get_parent().add_child(newCrumb)
	
