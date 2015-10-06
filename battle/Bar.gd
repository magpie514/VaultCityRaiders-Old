tool
extends Control

export var color = Color(1.0, 1.0, 1.0, 1.0)
export var value = float(1.0)

func set_value(val):
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
	var rect = Rect2(Vector2(), get_size()*Vector2(f, 1.0))
	draw_rect(rect, color)
	#FIXME:8 Can be optimized? Can be made prettier? @GUI
