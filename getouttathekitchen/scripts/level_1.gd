extends Node2D

@export var mob_scene: PackedScene

func _ready() -> void:
	$mobtimer.start()

func _process(delta: float) -> void:
	pass

func _on_mobtimer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D.
	var mob_spawn_location = $Player/MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	mob.target = $Player
	
	print(mob)
	
	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position
	# Spawn the mob by adding it to the Main scene.
	$NavigationRegion2D.add_child(mob)
	var count = 0
	for child in get_children():
		if child.is_in_group("mobs"):
			count+= 1
		print(count)
