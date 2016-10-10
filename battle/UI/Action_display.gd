extends Control

const actDisplayPos = [ Vector2(0, 108), Vector2(630, 108) ]
onready var panel = get_node("Panel")

func init(name, type, side):
	if side == 1:
		panel.set_pos(actDisplayPos[0])
		panel.direction = 3
	else:
		panel.set_pos(actDisplayPos[1])
		panel.direction = 2

	panel.get_node("Name").set_text(name)
	panel.get_node("Type").set_text(type)
	get_node("Timer").set_wait_time(3.0)
	get_node("Timer").start()
	panel.start()

func stop():
	get_node("Timer").stop()
	panel.stop()
