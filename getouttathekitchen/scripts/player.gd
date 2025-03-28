extends CharacterBody2D

signal hit

@export var speed = 400
@export var rotation_speed = 1.5  # turning speed in radians/sec
var screen_size
#stats for player
@export var _stat_health = 100
@export var _stat_damage = 1
@export var _stat_defense = 2
@export var _stat_speed = 1

#stats for weapons
@export var _stat_player_amount: float = 0		#0
@export var _stat_player_cd: float = 0			#1
@export var _stat_player_damage: float = 0		#2
@export var _stat_player_duration: float = 0	#3
@export var _stat_player_pierce: float = 0		#4
@export var _stat_player_size: float = 0		#5
@export var _stat_player_speed: float = 0		#6

var stats_array: Array[float] = []
var health = _stat_health
#where the weapons should be stored
@export var _current_weapons: Array [Node]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	healthbar_update(health)
	stats_array = [_stat_player_amount, _stat_player_cd,_stat_player_damage, _stat_player_duration, _stat_player_pierce, _stat_player_size, _stat_player_speed]
	screen_size = get_viewport_rect().size
	
	_pass_down_stats()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var velocity = Vector2.ZERO
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
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		move_and_slide()
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		

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
	if(body.is_in_group("mobs")):
		var damage = body.damage
		if (health - damage > 0):
			health -= damage
			healthbar_update(health)
		else:
			hide ()
			hit.emit()
			$CollisionShape2D.set_deferred("disabled", true)

func healthbar_update(health):
	$HealthBar.value = health
