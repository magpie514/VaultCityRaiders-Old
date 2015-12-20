extends Control

var fileout="."
var editorCurrentSkill = -1
var skillLib = {}
var tagCount = 0
var currentTag = ""

var nodes = {
	main = null,
	tagSelector = {
		tag = {
			add = null,
			del = null,
			ren = null,
			edit1 = null,
			edit2 = null
		}
	}
}

func _ready():
	nodes.main = get_node("/root/Global")
	nodes.tagSelector.tag.add = get_node("TagSelector/Tag/TagButtonAdd")
	nodes.tagSelector.tag.del = get_node("TagSelector/Tag/TagButtonDel")
	nodes.tagSelector.tag.ren = get_node("TagSelector/Tag/TagButtonRen")
	nodes.tagSelector.tag.edit = get_node("TagSelector/Tag/LineEdit")
	nodes.tagSelector.tag.edit2 = get_node("TagSelector/Tag/LineEdit2")
	get_node("Body/Effect/FileDialog").set_mode(FileDialog.MODE_OPEN_FILE)
	
	get_node("Body/sType/OptionButton").add_item("Status", nodes.main.SKILL_TYPE_EFFECT)
	get_node("Body/sType/OptionButton").add_item("Energy", nodes.main.SKILL_TYPE_ENERGY)
	get_node("Body/sType/OptionButton").add_item("Kinetic", nodes.main.SKILL_TYPE_KINETIC)


	get_node("Body/Source/OptionButton").add_item("EP", nodes.main.SKILL_SOURCE_EP)
	get_node("Body/Source/OptionButton").add_item("VP", nodes.main.SKILL_SOURCE_VP)
	get_node("LevelEdit/Damage1/OptionButton").add_item("None", nodes.main.ELEMENT_NONE)
	get_node("LevelEdit/Damage1/OptionButton").add_item("Normal", nodes.main.ELEMENT_NORMAL)
	get_node("LevelEdit/Damage1/OptionButton").add_item("Fire", nodes.main.ELEMENT_FIRE)
	get_node("LevelEdit/Damage1/OptionButton").add_item("Gravity", nodes.main.ELEMENT_GRAVITY)
	get_node("LevelEdit/Damage1/OptionButton").add_item("Outsider", nodes.main.ELEMENT_OUTSIDER)
	get_node("LevelEdit/Damage2/OptionButton").add_item("None", nodes.main.ELEMENT_NONE)
	get_node("LevelEdit/Damage2/OptionButton").add_item("Normal", nodes.main.ELEMENT_NORMAL)
	get_node("LevelEdit/Damage2/OptionButton").add_item("Fire", nodes.main.ELEMENT_FIRE)
	get_node("LevelEdit/Damage2/OptionButton").add_item("Gravity", nodes.main.ELEMENT_GRAVITY)
	get_node("LevelEdit/Damage2/OptionButton").add_item("Outsider", nodes.main.ELEMENT_OUTSIDER)

func init(sk):
	get_node("Body").show()
	get_node("Body/Name/LineEdit").set_text(sk.name)
	get_node("Body/Effect/LineEdit").set_text(sk.effect)
	get_node("Body/sType/OptionButton").select(sk.sType)
	get_node("Body/Source/OptionButton").select(sk.powerSource)
	get_node("Body/Contact/CheckBox").set_pressed(sk.contact)
	get_node("Body/Levels/SpinBox").set_value(sk.levels)
	levelsSet(sk, sk.levels)
	get_node("Body/Overcost/HSliderText/HSlider").set_value(sk.overCost)
	skillButtonUpdate()

func skillAdd(t):
	print("Adding new skill to tag '", t, "'")
	return {
		name = "Skill Name",
		effect = "res://battle/effect/debug01.xscn",
		levels = 0,
		powerSource = nodes.main.SKILL_SOURCE_EP,
		contact = false,
		sType = nodes.main.SKILL_TYPE_KINETIC,
		overCost = 25,
		levelData = [ skillLevelNew(0), null, null, null, null, null, null, null, skillLevelNew(8) ]
	}

func skillLevelNew(l):
	print("Adding level... [", l, "]")
	return {
		EP = l * 100,
		AD = 0,
		absoluteAD = false,
		damage = [0,0, 0,0],
		hitRange = 0,
		accuracy = 100,
		effect = null
	}

func levelsSet(sk, l):
	for i in range(0, 8):
		if i <= l:
			get_node(str("Body/SkillLV", i + 1)).set_disabled(false)
		else:
			get_node(str("Body/SkillLV", i + 1)).set_disabled(true)
		get_node(str("Body/SkillLV", i + 1)).set_text(str("Level ", i + 1))
	if sk.levelData[l] == null:
		sk.levelData[l] = skillLevelNew(l) #TODO:999 'null'ify unused level slots.

func levelsEditor(l):
	editorCurrentSkill = l
	var L = skillLib[currentTag].levelData[l]
	get_node("LevelEdit").show()
	get_node("LevelEdit/Header").set_text(str("Level ", l + 1))
	get_node("LevelEdit/EnergyUse/HSlider").set_value(L.EP)
	get_node("LevelEdit/Accuracy/HSliderText/HSlider").set_value(L.accuracy)
	get_node("LevelEdit/AD/HSliderText/HSlider").set_value(L.AD)
	get_node("LevelEdit/AD/CheckBox").set_pressed(L.absoluteAD)
	get_node("LevelEdit/Damage1/OptionButton").select(L.damage[0])
	get_node("LevelEdit/Damage1/HSlider").set_value(L.damage[1])
	get_node("LevelEdit/Damage2/OptionButton").select(L.damage[2])
	get_node("LevelEdit/Damage2/HSlider").set_value(L.damage[3])
	get_node("LevelEdit/Range/HSliderText/HSlider").set_value(L.hitRange)

func skillButtonUpdate():
	get_node("Body/SkillButton").init(skillLib[currentTag], get_node("Body/SkillButton").testchar)

func _on_LineEdit_text_entered(text):
	skillLib[currentTag].name = text
	skillButtonUpdate()

func _on_EffectButton_pressed():
	get_node("Body/Effect/FileDialog").popup()

func _on_OptionButton_item_selected(ID):
	skillLib[currentTag].sType = ID
	skillButtonUpdate()

func _on_OptionButton2_item_selected(ID):
	skillLib[currentTag].powerSource = ID
	skillButtonUpdate()

func _on_FileDialog_file_selected(path):
	get_node("Body/Effect/LineEdit").set_text(path)
	skillLib[currentTag].effect = path
	skillButtonUpdate()

func _on_LevelsSpinBox_value_changed(value):
	levelsSet(skillLib[currentTag], value - 1)
	skillLib[currentTag].levels = value - 1
	skillButtonUpdate()

func _on_PrintButton_pressed():
	print(skillLib.to_json())
	get_node("TextEdit").show()
	get_node("TextEdit").set_text(skillLib.to_json())

func _on_HSlider_value_changed(value):
	skillLib[currentTag].overCost = value
	skillButtonUpdate()

func _on_SkillLV_pressed(l):
	levelsEditor(l)

func _on_levelEditCancelButton_pressed():
	get_node("LevelEdit").hide()

func _on_levelEditOKButton_pressed():
	var L = skillLib[currentTag].levelData[editorCurrentSkill]
	editorCurrentSkill = -1
	L.EP = get_node("LevelEdit/EnergyUse/HSlider").get_value()
	L.accuracy = get_node("LevelEdit/Accuracy/HSliderText/HSlider").get_value()
	L.AD = get_node("LevelEdit/AD/HSliderText/HSlider").get_value()
	L.absoluteAD = get_node("LevelEdit/AD/CheckBox").is_pressed()
	L.damage[0] = get_node("LevelEdit/Damage1/OptionButton").get_selected_ID()
	L.damage[1] = get_node("LevelEdit/Damage1/HSlider").get_value()
	L.damage[2] = get_node("LevelEdit/Damage2/OptionButton").get_selected_ID()
	L.damage[3] = get_node("LevelEdit/Damage2/HSlider").get_value()
	L.hitRange = get_node("LevelEdit/Range/HSliderText/HSlider").get_value()
	skillButtonUpdate()
	get_node("LevelEdit").hide()

func _on_levelEditRevertButton_pressed():
	levelsEditor(editorCurrentSkill)

func _on_DMG1HSlider_value_changed(value):
	get_node("LevelEdit/Damage1/Label").set_text(str(value))

func _on_DMG2HSlider_value_changed(value):
	get_node("LevelEdit/Damage2/Label").set_text(str(value))

func _on_EUHSlider_value_changed(value):
	get_node("LevelEdit/EnergyUse/Label").set_text(str(value))

func _on_TagButtonAdd_pressed():
	nodes.tagSelector.tag.edit.show()
	nodes.tagSelector.tag.edit.grab_focus()

func _on_TagButtonDel_pressed():
	skillLib[currentTag] = null

func _on_TagLineEdit_text_entered(text):
	if not text in skillLib:
		skillLib[text] = skillAdd(text)
		print(skillLib[text])
	else:
		return
	get_node("TagSelector/Tag").add_item(text, tagCount)
	nodes.tagSelector.tag.edit.hide()
	tagCount += 1
	currentTag = text
	init(skillLib[currentTag])

func _on_Tag_item_selected(ID):
	currentTag = get_node("TagSelector/Tag").get_item_text(ID)
	init(skillLib[currentTag])

func _on_TagButtonRen_pressed():
	nodes.tagSelector.tag.edit2.set_text(currentTag)
	nodes.tagSelector.tag.edit2.show()
	nodes.tagSelector.tag.edit2.grab_focus()

func _on_LineEdit2_text_entered(text):
	if skillLib.has(text):
		nodes.tagSelector.tag.edit2.set_text(currentTag)
	else:
		var i = get_node("TagSelector/Tag").get_selected_ID()
		nodes.tagSelector.tag.edit2.hide()
		skillLib[text] = skillLib[currentTag]
		skillLib.erase(currentTag)
		get_node("TagSelector/Tag").set_item_text(i, text) #It won't update, help. TODO:99 file a bug.
		currentTag = text
		init(skillLib[text])
	
