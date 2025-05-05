extends CharacterBody2D

signal hit

@export var rotation_speed = 1.5  # turning speed in radians/sec
var screen_size
#stats for player
@export var _stat_health = 100
@export var _stat_defense = 2
@export var _stat_speed = 1

@export var _knockback_strength = 1000

#stats for weapons
@export var _stat_player_amount: float = 6		#0
@export var _stat_player_cd: float = 0			#1
@export var _stat_player_damage: float = 0		#2
@export var _stat_player_duration: float = 0	#3
@export var _stat_player_pierce: float = 0		#4
@export var _stat_player_size: float = 0		#5
@export var _stat_player_speed: float = 0		#6


var stats_array: Array[float] = []
var health = _stat_health
var invincible = false
var boost = 0
var boostTimeMax = 360 #adjust in increments of 120
var boostTime = boostTimeMax 
var damageAngle: float
var damageLocation: Vector2
var gotHit = false 
var knockbacktime = 0
#where the weapons should be stored
@export var _current_weapons: Array [WeaponBase] 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthBar.value = health
	$BoostBar.max_value = boostTime
	$BoostBar.value = boostTime
	stats_array = [_stat_player_amount, _stat_player_cd,_stat_player_damage, _stat_player_duration, _stat_player_pierce, _stat_player_size, _stat_player_speed]
	screen_size = get_viewport_rect().size

	
	
	_pass_down_stats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	var velocity = Vector2.ZERO
	if  knockbacktime <= 0:
		if Input.is_action_pressed("move_left"):
			velocity.x -=1
			$AnimatedSprite2D.animation = "left"
		if Input.is_action_pressed("move_right"):
			velocity.x +=1
			$AnimatedSprite2D.animation = "right"
		if Input.is_action_pressed("move_up"):
			velocity.y -=1
			$AnimatedSprite2D.animation = "up"
		if Input.is_action_pressed("move_down"):
			velocity.y +=1
			$AnimatedSprite2D.animation = "down"
		if Input.is_action_pressed("special") and boostTime > 0: 
				boost = 200
				boostbar_update(-5)
				if boostTime < 0:
					$boostWait.start()
		if $boostWait.is_stopped() and boostTime < boostTimeMax:
			boostbar_update(2)
		if velocity.length() > 0: 
			velocity = velocity.normalized() * (_stat_speed + boost)
			move_and_slide()
			boost = 0
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.stop()
	else:
		velocity = Vector2(cos(damageAngle) * _knockback_strength, sin(damageAngle) * _knockback_strength)
		move_and_slide()
		knockbacktime -= 1
	gotHit = false

	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func upgrade_stat(type: int,amount: float) -> void:
	#amount should be some amount  < 1 typically
	stats_array[type] = stats_array[type] + amount

func _pass_down_stats() ->void:
	print_debug("working?")
	for i in range(_current_weapons.size()):
		_current_weapons[i].update_player_stats(stats_array)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if(body.is_in_group("mobs") and !invincible):
		var damage = body.damage
		damageAngle = $CollisionShape2D.get_angle_to(body.global_position) + 3.14
		print(damageAngle)
		if (health - damage > 0):
			knockbacktime = 10
			if damage - _stat_defense < 1:
				damage = 1
			health -= damage
			healthbar_update(health)
			invincible = true
			boost = 200
			$AnimatedSprite2D.modulate = Color.BLACK
			$damageTimer.start()
		else:
			hide ()
			hit.emit()
			$CollisionShape2D.set_deferred("disabled", true)
			get_tree().change_scene_to_file("res://Scenes/youlose.tscn")

func healthbar_update(new_health):
	$HealthBar.value = new_health

func boostbar_update(value):
	boostTime += value
	$BoostBar.value += value


func _on_damage_timer_timeout() -> void:
	$AnimatedSprite2D.modulate = Color.WHITE
	invincible = false
	boost = 0

func adjustHealth(amount):
	_stat_health += amount
	health = _stat_health
	$HealthBar.max_value = _stat_health
	$HealthBar.value = health

func adjustDam(amount):
	_stat_player_damage += amount
	upgrade_stat(2, amount)
	_pass_down_stats()

func adjustDef(amount):
	_stat_defense += amount

func adjustSpeed(amount):
	_stat_speed += amount

func adjustNum(amount):
	_stat_player_amount += amount
	upgrade_stat(0, amount)
	_pass_down_stats()

func adjustDuration(amount):
	_stat_player_duration += amount
	upgrade_stat(3, amount)
	_pass_down_stats()

func adjustSize(amount):
	_stat_player_size += amount
	upgrade_stat(5, amount)
	_pass_down_stats()
