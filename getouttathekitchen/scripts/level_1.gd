extends Node2D

@export var mob_scene: PackedScene
@export var boss_scene: PackedScene
@export var lv1 : PackedScene
@export var lv2 : PackedScene
@export var lv3 : PackedScene
@export var lv4 : PackedScene
@export var card : PackedScene

@export var mob_cap: int = 0

var mobAmount = 0
@onready var lvArray = [lv1, lv2, lv3, lv4]
var mob_boost
var currentLevel
var carbVal = 0
var vegVal = 0
var fruitVal = 0
var meatVal = 0
var sugarVal = 0
var dairyVal = 0
var wait = false

func _ready() -> void:
	#currentLevel = lvArray.pop_front().instantiate()
	#add_child(currentLevel)
	load_new()
	#$mobtimer.start()

func _process(_delta: float) -> void:
	$Player/Camera2D/Time.text = str($matchtimer.time_left).pad_decimals(2)
	#if(lvArray.size() == 0):
		#$Player/Camera2D.global_position = $InitialSpawn.global_position
	#if Input.is_action_pressed("special"):
		#load_new()

func _on_mobtimer_timeout() -> void:
	# Create a new instance of the Mob scene.
	if mobAmount < mob_cap:
		if (wait == false):
			var mob = mob_scene.instantiate()
			mobAmount += 1
			# Choose a random location on Path2D.
			var mob_spawn_location: PathFollow2D = $Player/MobPath/MobSpawnLocation
			#print(mob_spawn_location.get_child(0).get_overlapping_areas())
			mob_spawn_location.progress_ratio = randf()
			mob.target = $Player
			
			#if a player is in a food types' area then make that food's enemies 50% more likely to spawn
			#Currently the valuss are set at 50% but we can make them higher if we like. 
			mob_boost = $Player/areadetector.get_overlapping_areas()
			var mobarray = []
			for i in mob_boost:
				if i.is_in_group("areagroup"):
					mobarray.append(i)
					#print(mobarray)
			if(mobarray.size() > 0):
				var randValue = randi_range(0,mobarray.size())
				if (randValue != 0):
					mob_boost = mobarray[randValue-1].name
				else:
					mob_boost = ""
			else:
				mob_boost = ""
		
			#print(mob_boost)
			if(mob_boost != null):
				#print(mob_boost)
				mob.animtype(mob_boost)
			
			# Set the mob's position to the random location.
			mob.global_position = mob_spawn_location.global_position
			# Spawn the mob by adding it to the Main scene.
			print("wait = " + str(wait))
			
			add_child(mob)
			print("I spawned")
		wait = false

func lowerMobCount():
	mobAmount -= 1



func load_new():
	if lvArray.size() > 0:
		add_child(lvArray[0].instantiate())
	#else:
		#get_tree().change_scene_to_file("res://Menus/MenuScenes/MainMenu.tscn")
	lvArray.pop_front()
	$Player.position = $InitialSpawn.global_position
	$padding.start()

func valueCalc():
	var total = sumValue()
	$Player/Camera2D/carb.max_value = total
	$Player/Camera2D/veg.max_value = total
	$Player/Camera2D/fruit.max_value = total
	$Player/Camera2D/meat.max_value = total
	$Player/Camera2D/sugar.max_value = total
	$Player/Camera2D/dairy.max_value = total

	$Player/Camera2D/carb.value = carbVal
	$Player/Camera2D/veg.value = vegVal
	$Player/Camera2D/fruit.value = fruitVal
	$Player/Camera2D/meat.value = meatVal
	$Player/Camera2D/sugar.value = sugarVal
	$Player/Camera2D/dairy.value = dairyVal

func sumValue():
	return carbVal + vegVal + fruitVal + meatVal + sugarVal + dairyVal

func crumbGrab(crumbType):
	#I'm starting to regret not using a dictionary for all of this...
	match crumbType:
		"carb":
			carbVal += 1
		"meat":
			meatVal += 1
		"dairy":
			dairyVal += 1
		"sugar":
			sugarVal += 1
		"veg":
			vegVal += 1
		"fruit":
			fruitVal += 1
	valueCalc()

func maxVal():
	var i = max(carbVal, meatVal, dairyVal, sugarVal, vegVal, fruitVal)
	if i == carbVal:
		return "carb"
	if i == meatVal:
		return "meat"
	if i == dairyVal:
		return "dairy"
	if i == sugarVal:
		return "sugar"
	if i == vegVal:
		return "veg"
	if i == fruitVal:
		return "fruit"

func _on_matchtimer_timeout() -> void:
	$mobtimer.stop()
	$matchtimer.stop()
	#if lvArray.size() == 0:
		#get_tree().change_scene_to_file("res://Menus/MenuScenes/MainMenu.tscn")
	for i in $Player/winscreen.get_children():
		if i.is_in_group("cards"):
			i.queue_free()
	for i in get_children():
		if i.is_in_group('mobs') or (i.is_in_group('Level') and lvArray.size() != 0):
				i.queue_free()
	$Player/winscreen.visible = true
	cardLoader()


func cardLoader():
	var max = maxVal()
	var card1 = card.instantiate()
	var card2 = card.instantiate()
	var card3 = card.instantiate()
	var card4 = card.instantiate()
	card1.drawRandom(max)
	card2.drawRandom(max)
	card3.drawRandom(max)
	card4.drawRandom(max)
	card1.position = $Player/winscreen/CardLoc1.position
	card2.position = $Player/winscreen/CardLoc2.position
	card3.position = $Player/winscreen/CardLoc3.position
	card4.position = $Player/winscreen/CardLoc4.position
	$Player/winscreen.add_child(card1)
	$Player/winscreen.add_child(card2)
	$Player/winscreen.add_child(card3)
	$Player/winscreen.add_child(card4)

func startNewLevel():
	var boss = null
	$Player.health = $Player/HealthBar.max_value
	for i in $Player/winscreen.get_children():
		if i.is_in_group("cards"):
			i.queue_free()
	$Player/winscreen.visible = false
	if lvArray.size() > 0:
		add_child(lvArray[0].instantiate())
	else:
		#make boss spawn
		boss = boss_scene.instantiate()
		boss.position = Vector2(3100,600)
		add_child(boss)
		$matchtimer.stop()
		$Player/Camera2D.zoom = Vector2(.8,.8)
		$padding.start(10000000000000)
		#get_tree().change_scene_to_file("res://Menus/MenuScenes/MainMenu.tscn")
		make_ui_invis()
	$Player/winscreen.visible = false
	lvArray.pop_front()
	$Player.position = $InitialSpawn.global_position
	$padding.start()
	


func _on_padding_timeout() -> void:
	$mobtimer.start()
	$matchtimer.start()
	pass # Replace with function body.


func _on_area_2d_body_entered(body: StaticBody2D) -> void:
	print (body.get_groups())
	if (body.is_in_group("oob")):
		wait = true

func make_ui_invis() -> void:
	$Player/Camera2D/carb.visible = false
	$Player/Camera2D/veg.visible = false
	$Player/Camera2D/fruit.visible = false
	$Player/Camera2D/meat.visible = false
	$Player/Camera2D/sugar.visible = false
	$Player/Camera2D/dairy.visible = false
	$Player/Camera2D/Time.visible = false
	$"Player/Camera2D/Time Remaining".visible = false
