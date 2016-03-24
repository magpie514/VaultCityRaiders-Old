extends Control

signal _battlechoice2(action, slot, power, target)

var active = false
var choice = false
var character = null
var block = false
onready var main = get_node("/root/main") 


func _ready():
	pass

func init(char):
	character = char
	get_node("Main/NameLabel").set_text(character.name)
	block = false
	get_node("Main").start()

func _on_B_Skill_pressed():
	if block:
		return
	else:
		block = true
		main.sfxPlay("blip")
		for i in range(0, 4):
			#get_node(str("SkillChoice/S",i)).init(character.skills[i], character)
			get_node(str("SkillChoice/S",i)).init(main.skillLib["none"], character)
		get_node("SkillChoice").start()

func _on_skillChoice(slot, power):
	emit_signal("_battlechoice2", 1, slot, power, 0)
	main.sfxPlay("blip")
	#TODO:99 Hey, remember that, you know, skills should have a target.
	get_node("SkillChoice").stop()
#FIXME:99 Block other buttons when a main category has been chosen.


func _on_B_SkillBack_pressed():
	block = false
	get_node("SkillChoice").stop()


func _on_B_WeaponBack_pressed():
	block = false
	get_node("WeaponChoice").stop()


func _on_B_Weapon_pressed():
	if block: return
	else:
		block = true
		main.sfxPlay("blip")
		get_node("WeaponChoice").start()


func _on_B_Defend_pressed():
	emit_signal("_battlechoice2", 3, 0, 0, 0)
