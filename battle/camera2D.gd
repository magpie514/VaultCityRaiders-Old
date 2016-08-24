extends Camera2D

var zoomVal = Vector2(1.0, 1.0)
var zoomTarget = Vector2(1.0, 1.0)
var count = 0
var countMax = 0

func _ready():
	pass


func zoomLinear(Z, time):
	zoomVal = get_zoom()
	zoomTarget = Vector2(Z, Z) #No point on using irregular zoom
	count = time
	countMax = time
	set_process(true)

func zoom(Z):
	set_zoom(Vector2(Z, Z))

func _process(delta):
	set_zoom(zoomVal.linear_interpolate(zoomTarget, float(float(countMax-count)/float(countMax))))
	#set_zoom(zoomVal.cubic_interpolate(zoomTarget, zoomVal, zoomTarget, float(float(countMax-count)/float(countMax))))
	count -= 1
	if count == 0:
		set_zoom(zoomTarget)
		set_process(false)