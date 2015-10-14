tool
extends Control

export var color = Color(1.0, 1.0, 1.0, 1.0)
export var value = float(1.0) setget set_value
var rect = 0

func set_value(val):
	if val > 1:
		val = 1.0
	elif val < 0:
		val = 0.0
	value = val
	update()

func _draw():
	var f
	if value > 0.01:
		f = value
	elif value > 0.00001:
		f = 0.01
	else:
		f = 0
	draw_rect(Rect2(Vector2(), rect * Vector2(f, 1.0)), color)
	#FIXME:8 Can be optimized? Can be made prettier? @GUI

func _ready():
	rect = get_size()
