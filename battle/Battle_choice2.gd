extends Node

var character = null

func _ready():
	pass

func init(char):
	character = char
	get_node("Main/NameLabel").set_text(character.name)


func _on_SkillButton_skillChoice( slot, power ):
	pass

func _on_B_Skill_pressed():
	for i in range(0, 4):
		print(str("SkillChoice/S",i+1))
		get_node(str("SkillChoice/S",i+1)).init(character.skills[i], character)

	get_node("SkillChoice").show()

func _on_B_Back_pressed():
	get_node("SkillChoice").hide()

func _on_skillChoice(slot, power):
	print("Choice:", slot, ":", power)
