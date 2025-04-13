extends Path2D

const SIZE = 100
const NUM_POINTS = 64
const LOBES = 2  # 2 lobes = 4-leaf clover

func _ready() -> void:
	curve = Curve2D.new()
#so much math
	for i in NUM_POINTS:
		var t = (i / float(NUM_POINTS)) * TAU
		var r = SIZE * sin(LOBES * t)
		var point = Vector2(r * cos(t), r * sin(t))
		curve.add_point(point)

	#Close the loop smoothly
	curve.add_point(curve.get_point_position(0))
