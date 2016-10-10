extends Control

signal _battlechoice2(action, slot, power, target)
signal _battlechoiceCancel()

var active = false
var choice = false
var character = null
var block = false

func init(char):
	character = char
	block = false
	get_node("Main/NameLabel").set_text(char.name)
	get_node("Main/CharData/Vital/Label").set_text(str(char.stats.V, "/", char.baseStats.V))
	get_node("Main/CharData/Vital/ColorRampBar").value = float(char.stats.V) / float(char.baseStats.V)
	get_node("Main/CharData/EP/Label").set_text(str(char.stats.EP, "/", char.baseStats.EP))
	get_node("Main/CharData/EP/ColorRampBar").value = float(char.stats.EP) / float(char.baseStats.EP)
	get_node("Main/CharData/Over/Label").set_text(str(char.stats.over, "%"))
	get_node("Main/CharData/Over/ColorRampBar").value = float(char.stats.over) / 100.0
	get_node("Main/CharData/Over").set_text(str("Over" if char.baseStats.awakening else "???"))
	get_node("SkillChoice/OB_Button").set_disabled(true if char.stats.over < 100 else false)
	get_node("SkillChoice/OB_Button").set_text(str("Overburst" if char.baseStats.awakening else "???"))
	get_node("Main").start()

func _on_B_Skill_pressed():
	if block: return
	else:
		block = true
		main.sfxPlay("blip")
		for i in range(0, 4):
			#get_node(str("SkillChoice/S",i)).init(character.skills[i], character)
			get_node(str("SkillChoice/S",i)).init(main.skillDef["none"], character)
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
	main.sfxPlay("cancel")
	get_node("SkillChoice").stop()

func _on_B_WeaponBack_pressed():
	block = false
	main.sfxPlay("cancel")
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
	if block: return
	else:
		main.sfxPlay("cancel")
		emit_signal("_battlechoiceCancel")

func _on_OB_Button_pressed():
	get_node("SkillChoice").stop()
	get_node("OBChoice").start()

func _on_B_OBBack_pressed():
	get_node("OBChoice").stop()
	main.sfxPlay("cancel")
	get_node("SkillChoice").start()

func _on_B_ItemBack_pressed():
	pass # replace with function body
