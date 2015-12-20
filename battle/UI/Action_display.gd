extends Control

var timeout = 0
var powerCount = 0
var powerMax = 0

func _ready():
	pass

func _process(delta):
	if timeout > 0:
		timeout -= 1
		if powerCount < powerMax:
			powerCount += powerMax / 45
		else:
			powerCount = powerMax
		get_node("Panel/Power/EP").set_text(str(powerCount))
	else:
		get_node("Panel").stop()
		set_process(false)

func init(name, power, side):
	powerMax = power
	powerCount = 0
	timeout = 120
	get_node("Panel").start()
	get_node("Panel/Name").set_text(name)
	get_node("Panel/Power/EP").set_text(str(powerCount))
	set_process(true)
