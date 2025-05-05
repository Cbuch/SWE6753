extends CharacterBody2D
@export var target: CharacterBody2D
@export var health = 1000

var typing = "blank"

var damage = 25
var isAttacking =  false
var attack_points: Array[Vector2] = []
@export var Frostings: Array[Node2D] = []
func _ready():
	healthbar_setup()
	attack_points_setup()
	$AnimationPlayer.play("donut_Spin")
	frosting_off()
	default_dnut()
	$AttackTimer.start(3)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_down"):
		health = health - 100
	health_update()

	move_and_slide()

func die():
	#maybe some animation or something
	#add a winning thing?
	queue_free()

func _on_collision_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		health = health - area.get_parent().damage
		health_update()


func animtype(input: StringName):
	print(input)
	typing = input
	$AnimatedSprite2D.set_animation(input)

func healthbar_setup():
	$HealthBar.max_value = health
	
func health_update():
	#change donut?
	var dnut = 0
	$HealthBar.value=health
	if health <= 0:
		die()
	else: if health <= $HealthBar.max_value * .2:
		print_debug("Here we are")
		$"Collision Detector/DonutCollider".shape.radius = 130
		$AnimationPlayer.speed_scale = 2.6
		dnut = 4
	else: if health <= $HealthBar.max_value * .4:
		$AnimationPlayer.speed_scale = -2.2
		dnut = 3
	else: if health <= $HealthBar.max_value * .6:
		$AnimationPlayer.speed_scale = 1.8
		dnut = 2
	else: if health <= $HealthBar.max_value * .8:
		$AnimationPlayer.speed_scale = -1.4
		dnut = 1
	else: dnut = default_dnut()
	sprite_check(dnut)

func sprite_check(sprite_num: int) -> void:
	if($DonutSprites.animation != str(sprite_num)):
		$DonutSprites.animation = str(sprite_num)

func default_dnut() -> int:
	$AnimationPlayer.speed_scale = 1
	$"Collision Detector/DonutCollider".shape.radius = 250
	return 0

func _on_attack_timer_timeout() -> void:
	#pick half of the attack points and then send frosting down them.
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var attack_areas = []
	while attack_areas.size() < 4:
		var num = rng.randi_range(0, 7)
		if num not in attack_areas:
			attack_areas.append(num)
	
	for i in attack_areas.size():
		Frostings[i].position = attack_points[attack_areas[i]]
		frosting_on()
	$AttackTimer.start(7)

func attack_points_setup() -> void:
	#1280 wide
	
	var point_count = 0.0
	var point_max = 8.0
	while point_count < point_max:
		attack_points.append(Vector2((1280 * ((point_count+1)/point_max) - 640), 0))
		point_count += 1
	pass

func frosting_off() -> void:
	for f in Frostings:
		f.visible = false
		f.get_node("Area2D").set_deferred("monitorable", false)

func frosting_on() -> void:
	for f in Frostings:
		f.position.y = 0
		f.visible = true
		f.get_node("Area2D").set_deferred("monitorable", true)
