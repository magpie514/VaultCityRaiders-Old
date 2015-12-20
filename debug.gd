extends Node

# member variables here, example:
# var a=2
# var b="textvar"
var nodes = { root = null, tree = null }

func _ready():
	nodes.tree = get_tree()

func _on_B_Board_pressed():
	nodes.tree.change_scene("res://board/Generator.xscn")

func _on_B_Battle_pressed():
	nodes.tree.change_scene("res://battle/Battle.xscn")


func _on_B_Skill_pressed():
	nodes.tree.change_scene("res://tools/skilledit.xscn")
