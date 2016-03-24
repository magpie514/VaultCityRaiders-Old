extends Control

signal _battlechoice1(choice)

var active = false
var choice = false
onready var panel = get_node("Panel")

func _ready():
	self.stop()

func start():
	self.show()
	panel.start()

func stop():
	active = false
	panel.stop()

func _on_BFight_pressed():
	self.emit_signal("_battlechoice1", 1)
	self.stop()

func _on_BRun_pressed():
	get_tree().quit()

func _on_BTalk_pressed():
	self.emit_signal("_battlechoice1", 3)
	self.stop()

func _on_BSkill_pressed():
	self.emit_signal("_battlechoice1", 1)
	self.stop()

func _on_BItem_pressed():
	self.emit_signal("_battlechoice1", 5)
	self.stop()