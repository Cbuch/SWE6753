extends Area2D

var enemies_in_range: Array[Node2D] = []

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		enemies_in_range.append(body)

func _on_body_exited(body: Node2D) -> void:
	enemies_in_range.erase(body)

func get_closest_enemy() -> Node2D:
	if enemies_in_range.is_empty():
		return null

	var closest: Node2D = null
	var closest_distance := INF

	for enemy in enemies_in_range:
		if not is_instance_valid(enemy):
			continue

		var dist := global_position.distance_squared_to(enemy.global_position) #runs 1 line faster than "distance-to" because of Pythagorus
		if dist < closest_distance:
			closest_distance = dist
			closest = enemy

	return closest
	
func get_closest_enemy_direction() -> Vector2:
	if(get_closest_enemy() != null):
		print_debug(get_closest_enemy().name)
		return (get_closest_enemy().global_position - global_position).normalized()
	return Vector2(1,0)
