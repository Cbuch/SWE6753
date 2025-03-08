extends Area2D

signal hit

@export var speed = 400
var screen_size
#stats for player
@export var _stat_health = 100
@export var _stat_damage = 1
@export var _stat_defense = 2
@export var _stat_speed = 1

#stats for weapons
@export var _stat_player_amount = 1
@export var _stat_player_cd = 1
@export var _stat_player_duration = 1
@export var _stat_player_pierce = 1
@export var _stat_player_size = 1
@export var _stat_player_speed = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -=1
	if Input.is_action_pressed("move_down"):
		velocity.y +=1
	if Input.is_action_pressed("move_left"):
		velocity.x -=1
	if Input.is_action_pressed("move_right"):
		velocity.x +=1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	hide ()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
