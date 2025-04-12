extends Node2D

@export var mob_scene: PackedScene
@export var mob_cap: int = 0
var mobAmount = 0



var mob_boost

func _ready() -> void:
	
	$mobtimer.start()

func _process(delta: float) -> void:
	pass

func _on_mobtimer_timeout() -> void:
	# Create a new instance of the Mob scene.
	if mobAmount < mob_cap:
		var mob = mob_scene.instantiate()
		mobAmount += 1
	
		# Choose a random location on Path2D.
		var mob_spawn_location = $Player/MobPath/MobSpawnLocation
		
		mob_spawn_location.progress_ratio = randf()
		mob.target = $Player
		
		#if a player is in a food types' area then make that food's enemies 50% more likely to spawn
		#Currently the valuss are set at 50% but we can make them higher if we like. 
		mob_boost = $Player/areadetector.get_overlapping_areas()
		if(mob_boost.size() > 1):
			if (randi_range(0,1) == 1):
				mob_boost = mob_boost[1].name
			else:
				mob_boost = ""
		else:
			mob_boost = ""
	
		print(mob_boost)
		if(mob_boost != null):
			print(mob_boost)
			mob.animtype(mob_boost)
		
		# Set the mob's position to the random location.
		mob.global_position = mob_spawn_location.global_position
		# Spawn the mob by adding it to the Main scene.
		add_child(mob)

func lowerMobCount():
	mobAmount -= 1
