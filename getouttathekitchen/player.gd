extends Area2D

signal hit

@export var speed = 400
var screen_size

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
	position = position.clamp(Vector2.ZERO, screen_size)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	hide ()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
var paused = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):  
		_toggle_pause()

func _toggle_pause() -> void:
	paused = !paused
	print("Pause toggled. New state:", paused)

	get_tree().paused = paused

	var pause_menu = get_parent().get_node("PauseMenu")
	if pause_menu:
		pause_menu.visible = paused
		pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		print("ERROR: PauseMenu not found!")
