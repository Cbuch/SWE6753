extends WeaponBase

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func attack() -> void:
	adjust_stats()
	while (adjusted_stats[0] > projectile_list.size()): # 0 is amount
		var new_knife = projectile_list[0].duplicate(Node.DUPLICATE_USE_INSTANTIATION)  # Duplicate first knife
		projectile_list.append(new_knife)
		add_child(new_knife)  # Add it as a child so it appears in the scene
	#make a circle of points around the player relative to number of knives
	for i in range(adjusted_stats[0]):
		var follow = $WeaponCircle/CircleFollow  # Get PathFollow2D
		follow.progress_ratio = i / float(adjusted_stats[0])  # Position evenly around the circle
			# Assign the knife to the position of the path
		var direction = follow.position.normalized()
		projectile_list[i].position = Vector2(0,0)
		projectile_list[i].start_pos = Vector2(0,0)
		projectile_list[i].end_pos = follow.position + (direction * 150)
		projectile_list[i].rotation = direction.angle() + PI / 2
		
		projectile_list[i].visible = true  # Ensure the knife is visible
		projectile_list[i].set_deferred("monitoring", true)
		#projectile_list[i].get_node("AnimationPlayer").play("Knife_flip_up")


func _on_weapon_cd_timeout() -> void:
	attack()
	$weaponDuration.start()


func _on_weapon_duration_timeout() -> void:
	stop_attack()
	$weaponCD.start()
