extends WeaponBase

#@onready var clover_path: Path2D = $CloverPath
@onready var weapon_cd_timer: Timer = $weaponCD

const LAUNCH_INTERVAL := 0.26
var total_tenders := 0
var tenders_fired := 0
var firing := false
var curve_points: Array[Vector2] = []

func _on_weapon_cd_timeout() -> void:
	adjust_stats()
	total_tenders = adjusted_stats[0]
	tenders_fired = 0
	firing = true
	#curve_points = _sample_clover_curve_points(total_tenders)
	while (adjusted_stats[0] > projectile_list.size()): # 0 is amount
		var new_tender = projectile_list[0].duplicate(Node.DUPLICATE_USE_INSTANTIATION)  # Duplicate first knife
		projectile_list.append(new_tender)
		add_child(new_tender)
	fire_next_tender()

func fire_next_tender():
	if tenders_fired >= total_tenders:
		return

	var tender := projectile_list[tenders_fired]
	tender.tender_duration = adjusted_stats[3]
	tender.duration_start()
	tender.position = Vector2(0,0)
	tender.distance = 0
	tender.visible = true
	tender.set_deferred("monitoring", true)

	tenders_fired += 1
	print_debug(1.1/adjusted_stats[6])
	await get_tree().create_timer(1.1/adjusted_stats[6]).timeout
	fire_next_tender()

func _process(_delta: float) -> void:
	if firing and _all_tenders_invisible():
		firing = false
		weapon_cd_timer.start(_base_cd * (1/adjusted_stats[1]))

func _all_tenders_invisible() -> bool:
	for tender in projectile_list:
		if tender.visible:
			return false
	return true
