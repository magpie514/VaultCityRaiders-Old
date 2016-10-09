extends Position2D

var moveData = [0, 0, null, null] #[0]time, [1]max time, [2]target position, [3]origin position
var shakeData = [0, 0] #[0]time, [1]max time
onready var attackPos = get_node("SpritePos/AttackPos")
onready var spritePos = get_node("SpritePos")
onready var centerPos = get_node("SpritePos/CenterPos")

func _ready(): set_process(true)

func moveTo(pos, time):
	moveData[0] = time; moveData[1] = time; moveData[2] = pos
	moveData[3] = spritePos.get_global_pos()

func shake(time):
	shakeData[0] = time; shakeData[1] = time


func _process(delta):
	if moveData[2] != null and moveData[0] > 0:
		var t = float(moveData[0])/float(moveData[1])
		spritePos.set_global_pos(moveData[2].cubic_interpolate(moveData[3], moveData[2]*1.2, moveData[3]*0.8, t))
		moveData[0] -= 1
		if moveData[0] == 0:
			moveData[2] = null

	if shakeData[0] > 0:
		spritePos.set_pos(Vector2(0, -5 + randi()%10))
		shakeData[0] -= 1
		if shakeData[0] == 0:
			spritePos.set_pos(Vector2(0, 0))
