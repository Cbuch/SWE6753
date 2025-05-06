extends WeaponBase

#@onready var clover_path: Path2D = $CloverPath

const LAUNCH_INTERVAL := 0.26
var total_projectiles := 0
var projectiles_fired := 0
var firing := false
var curve_points: Array[Vector2] = []

func _on_weapon_cd_timeout() -> void:
	adjust_stats()
	total_projectiles = adjusted_stats[0]
	projectiles_fired = 0
	firing = true
	while (adjusted_stats[0] > projectile_list.size()): # 0 is amount
		var new_projectile = projectile_list[0].duplicate(Node.DUPLICATE_USE_INSTANTIATION)  # Duplicate first knife
		projectile_list.append(new_projectile)
		add_child(new_projectile)
	fire_next_projectile()

func fire_next_projectile():
	if projectiles_fired >= total_projectiles:
		return

	var projectile := projectile_list[projectiles_fired]
	projectile.orb_duration = adjusted_stats[3]
	projectile.duration_start()
	projectile.position = Vector2(0,0)
	projectile.visible = true
	projectile.set_deferred("monitoring", true)
#	projectile.direction = get_randomized_direction($EnemyTracker.get_closest_enemy_direction(),.5)
	projectile.direction = $EnemyTracker.get_closest_enemy_direction()

	projectiles_fired += 1
	#print_debug(1.1/adjusted_stats[6])
	await get_tree().create_timer(.2).timeout
	fire_next_projectile()

func _process(_delta: float) -> void:
	if firing and _all_orbs_invisible():
		firing = false
		weapon_cd_timer.start(_base_cd * (1/adjusted_stats[1]))

func _all_orbs_invisible() -> bool:
	for projectile in projectile_list:
		if projectile.visible:
			return false
	return true


func get_randomized_direction(direction: Vector2, spread_angle_deg: float) -> Vector2:
	var spread_rad = deg_to_rad(spread_angle_deg)
	var random_angle = randf_range(-spread_rad / 2, spread_rad / 2)
	return direction.rotated(random_angle).normalized()
