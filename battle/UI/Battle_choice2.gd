extends Control

signal _battlechoice2(action, slot, power, target)

var active = false
var choice = false
var character = null
var block = false

func init(char):
	character = char
	block = false
	get_node("Main/NameLabel").set_text(char.name)
	get_node("Main").start()

func _on_B_Skill_pressed():
	if block: return
	else:
		block = true
		main.sfxPlay("blip")
		for i in range(0, 4):
			#get_node(str("SkillChoice/S",i)).init(character.skills[i], character)
			get_node(str("SkillChoice/S",i)).init(main.skillLib["none"], character)
		get_node("SkillChoice").start()

func _on_attackChoice(slot, level):
	emit_signal("_battlechoice2", main.BATTLE_ACTION_WEAPON, slot, level, 0)
	main.sfxPlay("blip")
	get_node("WeaponChoice").stop()

func _on_skillChoice(slot, power):
	emit_signal("_battlechoice2", main.BATTLE_ACTION_SKILL, slot, power, 0)
	main.sfxPlay("blip")
	#TODO:99 Hey, remember that, you know, skills should have a target.
	get_node("SkillChoice").stop()


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
		get_node("WeaponChoice/WeaponWidget0").init(character.equip.weapon[0])
		get_node("WeaponChoice/WeaponWidget1").init(character.equip.weapon[1])
		get_node("WeaponChoice").start()

func _on_B_Defend_pressed():
	if block: return
	else:
		main.sfxPlay("blip")
		emit_signal("_battlechoice2", main.BATTLE_ACTION_DEFEND, 0, 0, 0)

func _on_B_Back_pressed():
	pass # replace with function body
