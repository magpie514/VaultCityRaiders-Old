extends Node
onready var nodes = { root = null, tree = get_tree(), panel = get_node("Panel") }

func _ready():
#	nodes.tree = get_tree()
	pass

func _on_B_Board_pressed():
	nodes.tree.change_scene("res://board/Generator.xscn")

func _on_B_Battle_pressed():
	nodes.tree.change_scene("res://battle/Battle.xscn")


func _on_B_Skill_pressed():
	nodes.tree.change_scene("res://tools/skilledit.xscn")
