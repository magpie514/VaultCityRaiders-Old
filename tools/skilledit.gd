extends Control

var fileout="."
var editorCurrentSkill = -1
var skillLib = {}
var tagCount = 0
var currentTag = ""

onready var nodes = {
	main = get_node("/root/main"),
	tagSelector = {
		tag = {
			add = get_node("TagSelector/Tag/TagButtonAdd"),
			del = get_node("TagSelector/Tag/TagButtonDel"),
			ren = get_node("TagSelector/Tag/TagButtonRen"),
			edit = get_node("TagSelector/Tag/LineEdit"),
			edit2 = get_node("TagSelector/Tag/LineEdit2")
		}
	},
	skillEditor = {
		name = get_node("SkillEdit/Name/LineEdit"),
	},
	textEdit = get_node("TextEdit"),
}

func elementListFill(OB):
	OB.add_item("None", main.ELEMENT_NONE)
	OB.add_item("Kinetic", main.ELEMENT_KINETIC)
	OB.add_item("Fire", main.ELEMENT_FIRE)
	OB.add_item("Cold", main.ELEMENT_COLD)
	OB.add_item("Electric", main.ELEMENT_ELEC)
	OB.add_item("Light", main.ELEMENT_LIGHT)
	OB.add_item("Dark", main.ELEMENT_DARK)
	OB.add_item("Gravity", main.ELEMENT_GRAVITY)
	OB.add_item("Outsider", main.ELEMENT_OUTSIDER)

func targetTypeListFill(N):
	N.add_item("Self", main.TARGET_SELF)
	N.add_item("Single", main.TARGET_SINGLE)
	N.add_item("V-Line", main.TARGET_VLINE)
	N.add_item("H-Line", main.TARGET_HLINE)
	N.add_item("Cone", main.TARGET_CONE)
	N.add_item("All", main.TARGET_ALL)

func targetSideListFill(N):
	N.add_item("Enemy", main.TARGET_SIDE_ENEMY)
	N.add_item("Own", main.TARGET_SIDE_OWN)
	N.add_item("All", main.TARGET_SIDE_ALL)


func _ready():
	get_node("SkillEdit/Effect/FileDialog").set_mode(FileDialog.MODE_OPEN_FILE)
	get_node("SkillEdit/Source/OptionButton").add_item("EP", nodes.main.SKILL_SOURCE_USER_EP)
	get_node("SkillEdit/Source/OptionButton").add_item("VP", nodes.main.SKILL_SOURCE_USER_VP)
	nodes.textEdit.set_wrap(true)
	elementListFill(get_node("LevelEdit/Damage1/OptionButton"))
	elementListFill(get_node("LevelEdit/Damage2/OptionButton"))
	targetTypeListFill(get_node("LevelEdit/Range/FormationChoice"))
	targetSideListFill(get_node("LevelEdit/Range/SideChoice"))

func init(sk):
	get_node("SkillEdit").show()
	get_node("SkillEdit/Name/LineEdit").set_text(sk.name)
	get_node("SkillEdit/Effect/LineEdit").set_text(sk.effect)
	get_node("SkillEdit/Source/OptionButton").select(sk.powerSource)
	get_node("SkillEdit/Levels/SpinBox").set_value(sk.levels)
	get_node("SkillEdit/Overcost/SpinBox").set_value(sk.overCost)
	levelsSet(sk, sk.levels)
	skillButtonUpdate()

func skillAdd(t):
	print("Adding new skill to tag '", t, "'")
	return {
		name = "Skill Name",
		effect = "res://battle/effect/debug01.tscn",
		levels = 0,
		powerSource = nodes.main.SKILL_SOURCE_USER_EP,
		overCost = 25,
		levelData = [ skillLevelNew(0), null, null, null, null, null, null, null, skillLevelNew(8) ]
	}

func skillLevelNew(l):
	print("Adding level... [", l, "]")
	return {
		contact = false,
		EP = l * 100,
		AD = 0,
		absoluteAD = false,
		damage = [0,0, 0,0],
		target = [0, 1, 0],
		ACC = 100,
		AGI = 0,
		effect = null
	}

func levelsSet(sk, l):
	for i in range(0, 8):
		if i <= l:	get_node(str("SkillEdit/SkillLV", i + 1)).set_disabled(false)
		else: get_node(str("SkillEdit/SkillLV", i + 1)).set_disabled(true)
		get_node(str("SkillEdit/SkillLV", i + 1)).set_text(str("Level ", i + 1))
	if sk.levelData[l] == null:
		sk.levelData[l] = skillLevelNew(l) #TODO:999 'null'ify unused level slots.

func levelsEditor(l):
	editorCurrentSkill = l
	var L = skillLib[currentTag].levelData[l]
	get_node("LevelEdit").show()
	get_node("LevelEdit/Header").set_text(str("Level ", l + 1))
	get_node("LevelEdit/Contact/CheckBox").set_pressed(L.contact)
	get_node("LevelEdit/EnergyUse/SpinBox").set_value(L.EP)
	get_node("LevelEdit/Accuracy/SpinBox").set_value(L.ACC)
	get_node("LevelEdit/AD/SpinBox").set_value(L.AD)
	get_node("LevelEdit/AD/CheckBox").set_pressed(L.absoluteAD)
	get_node("LevelEdit/Damage1/OptionButton").select(L.damage[0])
	get_node("LevelEdit/Damage1/SpinBox").set_value(L.damage[1])
	get_node("LevelEdit/Damage2/OptionButton").select(L.damage[2])
	get_node("LevelEdit/Damage2/SpinBox").set_value(L.damage[3])
	get_node("LevelEdit/Range/SpinBox").set_value(L.target[2])
	get_node("LevelEdit/Range/FormationChoice").select(L.target[1])
	get_node("LevelEdit/Range/SideChoice").select(L.target[0])
	get_node("LevelEdit/AGIBonus/SpinBox").set_value(L.AGI)

func skillButtonUpdate():
	get_node("SkillEdit/SkillButton").init(skillLib[currentTag], get_node("SkillEdit/SkillButton").testchar)


# Signals ######################################################################
#- Skill editor signals --------------------------------------------------------
func _on_OptionButton_item_selected(ID):
	skillLib[currentTag].sType = ID
	skillButtonUpdate()

func _on_OptionButton2_item_selected(ID):
	skillLib[currentTag].powerSource = ID
	skillButtonUpdate()

func _on_FileDialog_file_selected(path):
	get_node("SkillEdit/Effect/LineEdit").set_text(path)
	skillLib[currentTag].effect = path
	skillButtonUpdate()

func _on_EffectButton_pressed():
	get_node("SkillEdit/Effect/FileDialog").popup()

func _on_LevelsSpinBox_value_changed(value):
	levelsSet(skillLib[currentTag], value - 1)
	skillLib[currentTag].levels = value - 1
	skillButtonUpdate()

func _on_LevelsOverCostSpinBox_value_changed(value):
	skillLib[currentTag].overCost = value
	skillButtonUpdate()

func _on_NameLineEdit_text_entered(text):
	skillLib[currentTag].name = text
	skillButtonUpdate()

func _on_SkillLV_pressed(l):
	levelsEditor(l)

func _on_PrintButton_pressed():
	var out = skillLib.to_json()
	nodes.textEdit.show()
	nodes.textEdit.set_text(out)

func _on_CheckBox_toggled(pressed):
	skillLib[currentTag].contact = pressed
	skillButtonUpdate()


#- Tag widget signals ----------------------------------------------------------
func _on_Tag_item_selected(ID):
	currentTag = get_node("TagSelector/Tag").get_item_text(ID)
	init(skillLib[currentTag])

func _on_TagButtonAdd_pressed():
	nodes.tagSelector.tag.edit.show()
	nodes.tagSelector.tag.edit.grab_focus()

func _on_TagButtonDel_pressed():
	skillLib[currentTag] = null

func _on_TagButtonRen_pressed():
	nodes.tagSelector.tag.edit2.set_text(currentTag)
	nodes.tagSelector.tag.edit2.show()
	nodes.tagSelector.tag.edit2.grab_focus()

func _on_TagLineEdit_text_entered(text):
	if not text in skillLib:
		skillLib[text] = skillAdd(text)
		print(skillLib[text])
	else: return
	get_node("TagSelector/Tag").add_item(text, tagCount)
	nodes.tagSelector.tag.edit.hide()
	tagCount += 1
	currentTag = text
	init(skillLib[currentTag])

func _on_TagLineEdit2_text_entered(text):
	if skillLib.has(text): nodes.tagSelector.tag.edit2.set_text(currentTag)
	else:
		var i = get_node("TagSelector/Tag").get_selected_ID()
		nodes.tagSelector.tag.edit2.hide()
		skillLib[text] = skillLib[currentTag]
		skillLib.erase(currentTag)
		get_node("TagSelector/Tag").set_item_text(i, text) #It won't update, help. TODO:99 file a bug.
		currentTag = text
		init(skillLib[text])


#- Level editor signals --------------------------------------------------------
func _on_levelEditCancelButton_pressed():
	get_node("LevelEdit").hide()

func _on_levelEditOKButton_pressed():
	var L = skillLib[currentTag].levelData[editorCurrentSkill]
	editorCurrentSkill = -1
	L.contact = get_node("LevelEdit/Contact/CheckBox").is_pressed()
	L.EP = get_node("LevelEdit/EnergyUse/SpinBox").get_value()
	L.ACC = get_node("LevelEdit/Accuracy/SpinBox").get_value()
	L.AD = get_node("LevelEdit/AD/SpinBox").get_value()
	L.AGI = get_node("LevelEdit/AGIBonus/SpinBox").get_value()
	L.absoluteAD = get_node("LevelEdit/AD/CheckBox").is_pressed()

	L.damage[0] = get_node("LevelEdit/Damage1/OptionButton").get_selected_ID()
	L.damage[1] = get_node("LevelEdit/Damage1/SpinBox").get_value()
	L.damage[2] = get_node("LevelEdit/Damage2/OptionButton").get_selected_ID()
	L.damage[3] = get_node("LevelEdit/Damage2/SpinBox").get_value()

	L.target[0] = get_node("LevelEdit/Range/SideChoice").get_selected_ID()
	L.target[1] = get_node("LevelEdit/Range/FormationChoice").get_selected_ID()
	L.target[2] = get_node("LevelEdit/Range/SpinBox").get_value()
	skillButtonUpdate()
	get_node("LevelEdit").hide()

func _on_levelEditRevertButton_pressed():
	levelsEditor(editorCurrentSkill)

func _on_LevelEditEnergyUseHSlider_value_changed(value):
	get_node("LevelEdit/EnergyUse/Label").set_text(str(value))



