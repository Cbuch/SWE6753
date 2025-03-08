extends Node

class_name WeaponBase

#stats for weapons
#these should remain static as base stats, so player stats should be seperate
#make any irrelevant stat <= 0
@export var _stat_weapon_amount = 1		#0
@export var _stat_weapon_cd = 1			#1
@export var _stat_weapon_duration = 1	#2
@export var _stat_weapon_pierce = 1		#3
@export var _stat_weapon_size = 1		#4
@export var _stat_weapon_speed = 1		#5  remember to scale any animation speed with this

var player_stats: Array[float] = [1,1,1,1,1,1]

var weapon_stats: Array[float] = [1,1,1,1,1,1]

func _ready() -> void:
	weapon_stats = [_stat_weapon_amount, _stat_weapon_cd, _stat_weapon_duration, _stat_weapon_pierce, _stat_weapon_size, _stat_weapon_speed]
	
	#all weapons should have a timer attached to them to make their attacks work if cd > 0
	if (_stat_weapon_cd > 0):
		$weaponCD.wait_time = _stat_weapon_cd
	pass # Replace with function body.

func attack() ->void:
	print_debug("This is shooting wrong buddy")

func upgrade_stat(type: int,amount: float) -> void:
	#amount should be some amount  < 1 typically
	weapon_stats[type] = weapon_stats[type] + amount
	pass
	
func update_player_stats(new_stats: Array[float]) -> void:
	for i in range(new_stats.size()):  #Should be 6
		player_stats[i] = new_stats[i]
