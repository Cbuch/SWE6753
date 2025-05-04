extends Control

@export var chances = 7
var options = ["meat", "carb", "dairy", "sugar", "veg", "fruit"]
@onready var player = get_parent().get_parent()
var yourCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func drawRandom(input: String):
	for i in chances:
		options.append(input)
	var randValue = randi_range(0,(options.size() - 1))
	var recipebook = getRecipeBook(options[randValue - 1])
	randValue = randi_range(0,(recipebook.size() - 1))
	yourCard = recipebook[randValue]
	var image = load(yourCard[0])
	$TextureButton.set_texture_normal(image) 

func getRecipeBook(input: String):
	
	#Categories
	var carbRecipes = [
		["res://art/Cards/Card_ArtisanLoaf.png", 'health', 50],
		["res://art/Cards/Card_CinnamonRoll.png", 'health', 100]
	]
	var fruitRecipes = [
		["res://art/Cards/Card_FruitSalad.png", 'duration', .1],
		["res://art/Cards/Card_RoastWatermelon.png", 'duration', .2]
	]
	var vegRecipes = [
		["res://art/Cards/Card_TomatoSoup.png", "speed", 100],
		["res://art/Cards/Card_EggplantParm.png", "speed", 200]
	]
	var meatRecipes = [
		["res://art/Cards/Card_Steak.png", "damage", 25],
		["res://art/Cards/Card_Beans.png", "defense", 10]
	]
	var dairyRecipes = [
		["res://art/Cards/Card_CheeseWheel.png","size", 1.25],
		["res://art/Cards/Card_Milkshake.png", "size", 1.5]
	]
	var sugarRecipes = [
		["res://art/Cards/Card_CheeseWheel.png", "number", 1],
		["res://art/Cards/Card_Milkshake.png", "number", 2]
	]
	
	#Master book
	var myRecipeBook = {
		"carb": carbRecipes,
		"fruit": fruitRecipes,
		"veg": vegRecipes,
		"meat": meatRecipes,
		"dairy": dairyRecipes,
		"sugar": sugarRecipes
	}
	
	if myRecipeBook.has(input):
		return myRecipeBook.get(input)
	else:
		return null
	

func makeAdjustment(type, value):
	match type:
		'health':
			player.adjustHealth(value)
		'duration':
			player.adjustDuration(value)
		'speed':
			player.adjustSpeed(value)
		'damage':
			player.adjustDam(value)
		'defense':
			player.adjustDef(value)
		'size':
			player.adjustSize(value)
		'number':
			player.adjustNum(value)

func _on_texture_button_pressed() -> void:
	makeAdjustment(yourCard[1], yourCard[2])
	player.get_parent().startNewLevel()
