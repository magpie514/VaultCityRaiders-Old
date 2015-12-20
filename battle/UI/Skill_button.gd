extends Button

signal skillChoice(slot, power)

export(int) var slot = 0
export(bool) var debug = false

var level = 0
var character = null
var skill = null

var nodes = {
	main = null,
	icons = { sType = null,	contact = null },
	labels = { level = null, EP = null },
	bars = { level = null },
}

var testchar = {
	stats = {
		EP = 50000,
		MEP = 50000,
		over = 100,
	}
}
static func interpolate(a, b, x):
	return (a * (1.0 - x) + b * x)
	
func _ready():
	nodes.main = get_node("/root/Global")
	nodes.labels.level = get_node("EP_Display/LevelLabel")
	nodes.labels.EP = get_node("EP_Display/EPLabel")
	nodes.bars.level = get_node("EP_Display/LevelLabel/ColorRampBar")
	if debug:
		init(nodes.main.skillLib["none"], testchar)
	set_process(true)

func _process(delta):
	pass

#TODO:50 Find a way to make the last power level be remembered. @Combat @GUI +Brainstorm
func init(act, char):
	skill = act
	character = char
	get_node("NameLabel").set_text(act.name)
	if skill.sType == nodes.main.SKILL_TYPE_ENERGY:
			get_node("TypeIcon").set_modulate(Color(.8,0,.8))
	elif skill.sType == nodes.main.SKILL_TYPE_KINETIC:
		get_node("TypeIcon").set_modulate(Color(.4,.4,.4))
	elif skill.sType == nodes.main.SKILL_TYPE_EFFECT:
		get_node("TypeIcon").set_modulate(Color(.4,.4,.8))
		
	if skill.contact:
		get_node("ContactIcon").set_modulate(Color(.6,.2,.2))
	else:
		get_node("ContactIcon").set_modulate(Color(.2,.6,.8))
	
	if skill.levelData[0].EP > character.stats.EP:
		get_node("EP_Display/LevelLabel/MaxBar").value = 0
		self.set_opacity(0.5)
		self.set_disabled(true)
		self.set_process(false)
		return
		
	get_node("EP_Display/LevelLabel/MaxBar").value = float(character.stats.EP)/float(character.stats.MEP)
	levelSet(0)
	self.set_process(true)

func levelSet(lv):
	if lv > skill.levels:
		if character.stats.over >= skill.overCost:
			level = 8
		else:
			level = skill.levels
	elif lv < 0:
		level = 0
	else:
		level = lv
	
	var levelLabel = ""
	if level == 8:
		levelLabel = "OVER"
	else:
		levelLabel = str("Level ", level + 1, "(", skill.levels + 1, ")")

	nodes.labels.level.set_text(levelLabel)
	get_node("ADIcon").set(skill.levelData[level].AD, skill.levelData[level].absoluteAD)
	
	if skill.levelData[level].damage[0] > 0:
		get_node("ElementIcon").show()
		get_node("ElementIcon/Label").set_text(str(skill.levelData[level].damage[1]))
	else:
		get_node("ElementIcon").hide()
	if skill.levelData[level].damage[2] > 0:
		get_node("ElementIcon2").show()
		get_node("ElementIcon2/Label").set_text(str(skill.levelData[level].damage[3]))
	else:
		get_node("ElementIcon2").hide()


	if skill.levelData[level].effect:
		get_node("EffectIcon").show()
		get_node("EffectIcon").set_tooltip(skill.levelData[level].effect)
	else:
		get_node("EffectIcon").hide()
		get_node("EffectIcon").set_tooltip("")

	get_node("ACCIcon/Label").set_text(str(skill.levelData[level].accuracy))
	
	nodes.labels.EP.set_text(str(skill.levelData[level].EP))
	nodes.bars.level.value = float(skill.levelData[level].EP)/float(character.stats.MEP)
	
func _on_B_Decrease_pressed():
	if level == 8:
		levelSet(skill.levels)
	else:
		levelSet(level - 1)
#	self.set_process(true)

func _on_B_Increase_pressed():
	levelSet(level + 1)
#	self.set_process(true)

func _on_SkillButton_pressed():
	self.emit_signal("skillChoice",slot, level)
