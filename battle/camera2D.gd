extends Camera2D

var zoomData = [0, 0, Vector2(1.0, 1.0), 0.0] #[0]Time, [1]Max Time, [2]Current, [3]Target
var followData = [false, null] #[0]Active, [1]Target Node

static func V(i): return Vector2(float(i), float(i))

func _ready():
	set_process(true)

func zoomLinear(Z, time):
	zoomData[0] = time; zoomData[1] = time
	zoomData[2] = get_zoom(); zoomData[3] = V(Z)

func zoom(Z): set_zoom(V(Z))

func resetPos():
	followData[0] = false; followData[1] = null
	set_pos(Vector2(400, 160))

func followTarget(node):
	if node != null:
		followData[0] = true
		followData[1] = node
		set_follow_smoothing(5.0)
	else:
		followData[0] = false
		followData[1] = null
		set_follow_smoothing(4.0)

func _process(delta):
	if zoomData[0] > 0:
		var t = float(zoomData[1] - zoomData[0]) / float(zoomData[1])
		set_zoom(zoomData[2].linear_interpolate(zoomData[3], t))
		zoomData[0] -= 1
		if zoomData[0] == 0: set_zoom(zoomData[3])
	if followData[0] and followData[1] != null:
		set_global_pos(followData[1].get_global_pos()-Vector2(0, 80))
