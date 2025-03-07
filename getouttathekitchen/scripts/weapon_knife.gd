extends WeaponBase

@export var knives = []
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func attack() -> void:
	#make a circle of points around the player relative to number of knives
	for i in range (_stat_weapon_amount):
		$Path2D/CircleFollow.progress_ratio = i/float(_stat_weapon_amount)
		#turn on knives that are parented to player and reset position
	#movement should be handled in _process maybe?
	pass
