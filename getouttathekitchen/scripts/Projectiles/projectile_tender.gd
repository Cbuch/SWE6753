extends ProjectileBase

@onready var sprite: Sprite2D = $Sprite2D
@export var anim_player: AnimationPlayer
@export var clover_curve: Path2D
@export var tender_duration: float
var distance: float

func _ready() -> void:
	$AnimationPlayer.play("tender_spin")
	clover_curve = $WeaponCurve  # fallback in case it's not assigned

func _process(delta: float) -> void:
	distance += speed * .002
	$WeaponCurve/CurveFollow.progress_ratio = distance
	position = $WeaponCurve/CurveFollow.position

func duration_start():
	$weaponDuration.start(5.0 * tender_duration)

func _on_weapon_duration_timeout() -> void:
	visible = false
	get_node("Area2D").set_deferred("monitorable", false)
	return
