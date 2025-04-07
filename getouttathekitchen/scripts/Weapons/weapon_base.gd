extends Node2D

class_name WeaponBase

#stats for weapons
#these should remain static as base stats, so player stats should be seperate
#make any irrelevant stat <= 0
@export var _stat_weapon_amount = 1		#0
@export var _stat_weapon_cd = 1			#1
@export var _stat_weapon_damage = 1		#2
@export var _stat_weapon_duration = 1	#3
@export var _stat_weapon_pierce = 1		#4
@export var _stat_weapon_size = 1		#5
@export var _stat_weapon_speed = 1		#6  remember to scale any animation speed with this

var player_stats: Array[float] = [1,1,1,1,1,1,1]

var weapon_stats: Array[float] = [1,1,1,1,1,1.1]

@export var adjusted_stats: Array[float] = [0,0,0,0,0,0,0]

@export var projectile_list: Array[Node2D] = []

func _ready() -> void:
	weapon_stats = [_stat_weapon_amount, _stat_weapon_cd,_stat_weapon_damage, _stat_weapon_duration, _stat_weapon_pierce, _stat_weapon_size, _stat_weapon_speed]
	
	#all weapons should have a timer attached to them to make their attacks work if cd > 0
	if (_stat_weapon_cd > 0):
		$weaponCD.start()
	
	for i in range (projectile_list.size()):
		projectile_list[i].visible = false
		projectile_list[i].set_deferred("monitoring", false)

func attack() ->void:
	print_debug("This is shooting wrong buddy")

func stop_attack() -> void:
	for i in range(projectile_list.size()):
		projectile_list[i].visible = false
		projectile_list[i].set_deferred("monitoring", false)


func upgrade_stat(type: int,amount: float) -> void:
	#amount should be some amount  < 1 typically
	weapon_stats[type] = weapon_stats[type] + amount

func update_stats(w_stats: Array[float]) -> void:
	for i in range(w_stats.size()):  #Should be 6
		weapon_stats[i] = w_stats[i]
		

func update_player_stats(p_stats: Array[float]) -> void:
	for i in range(p_stats.size()):  #Should be 6
		player_stats[i] = p_stats[i]
		

func adjust_stats() -> void:
	for i in range(adjusted_stats.size()):
		adjusted_stats[i] = player_stats[i] + weapon_stats[i]
	for i in range(projectile_list.size()):
		projectile_list[i].update_projectile_stats(adjusted_stats)

		#print_debug(adjusted_stats[i])
		#print_debug(player_stats[i])
		#print_debug(weapon_stats[i])
