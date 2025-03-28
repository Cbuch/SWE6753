extends Node2D

class_name ProjectileBase

@export var pierce = -1.0		#negative pierce = infinite
@export var base_pierce = -1.0
@export var size = 1.0
@export var base_size: float = .35
@export var speed = 1.0
@export var base_speed: float = 400.0
@export var damage = 1.0
@export var base_damage = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_projectile_stats(proj_stats: Array[float]) -> void:
		damage = proj_stats[2] * base_damage
		
		if(base_pierce > 0):
			pierce = proj_stats[4] + base_pierce
		
		size = proj_stats[5] * base_size
		scale = Vector2(size,size)
		
		speed = proj_stats[6] * base_speed
		$AnimationPlayer.speed_scale = proj_stats[6]
