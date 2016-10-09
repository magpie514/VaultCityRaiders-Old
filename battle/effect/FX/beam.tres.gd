tool
extends Position2D

export(int, 0, 2048) var length = 4
export(int, 0, 512) var width = 84
export(int, 0, 24) var vibrate = 0
export(float, 0.0, 1.0, 0.01) var colorRng = 1.0
export(ColorRamp) var colorRamp



onready var nodes = {
	orig = get_node("Origin"),
	body = get_node("Body")
}

func _process(delta):
	var l = float(length) / 4.0
	var w = (float(width + (randi() % (vibrate + 1)))) / 84.0
	nodes.body.set_scale(Vector2(l, w))
	nodes.orig.set_scale(Vector2(1.0, w))
	nodes.body.set_offset(Vector2((length / 8), -42))
	nodes.body.set_modulate(colorRamp.interpolate(colorRng))
	nodes.orig.set_modulate(colorRamp.interpolate(colorRng))

func _ready():
	vibrate = 0
	set_process(true)
