extends ProjectileBase

@onready var sprite: Sprite2D = $Sprite2D
@export var anim_player: AnimationPlayer
@export var orb_duration: float
var direction: Vector2
func _ready() -> void:
	$AnimationPlayer.play("orb_spin")

func _process(delta: float) -> void:
	position += direction * speed * delta

func duration_start():
	$weaponDuration.start(5.0 * orb_duration)

func _on_weapon_duration_timeout() -> void:
	visible = false
<<<<<<< HEAD
	set_deferred("monitoring", false)
=======
	get_node("Area2D").set_deferred("monitorable", false)
>>>>>>> 097248b532665735325d0327d2b6669c8fe5a362
	return
