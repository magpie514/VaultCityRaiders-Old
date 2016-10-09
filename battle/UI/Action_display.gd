extends Control

func init(name, side):
	get_node("Panel").start()
	get_node("Panel/Name").set_text(name)
