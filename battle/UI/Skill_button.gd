extends Button

signal skillChoice(slot, power)

export(int) var slot = 0
export(bool) var debug = false

var level = 0
var character = null
var skill = null

onready var nodes = {
	main = get_node("/root/main"),
	icons = {
		sType = get_node("TypeIcon"),
		contact = get_node("ContactIcon"),
		element1 = get_node("ElementIcon"),
		element2 = get_node("ElementIcon2"),
	},
	labels = {
		name = get_node("NameLabel"),
		level = get_node("EP_Display/LevelLabel"),
		EP = get_node("EP_Display/EPLabel"),
		element1 = get_node("ElementIcon/Label"),
		element2 = get_node("ElementIcon2/Label"),
	},
	bars = { level = get_node("EP_Display/LevelLabel/ColorRampBar") },
}

var testchar = {	stats = {	EP = 99999999,	MEP = 99999999,	over = 100,	}		}

static func interpolate(a, b, x):
	return (a * (1.0 - x) + b * x)
	
func _ready():
	#if debug:
	#	init(nodes.main.skillLib["none"], testchar)
	pass

func init(act, char):
	skill = act
	character = char
	nodes.labels.name.set_text(act.name)
	
	if skill.sType == nodes.main.SKILL_TYPE_COMBAT: nodes.icons.sType.set_modulate(Color(.8,0,.8))
	else: nodes.icons.sType.set_modulate(Color(.4,.4,.8))
	
	if skill.contact: nodes.icons.contact.set_modulate(Color(.6,.2,.2))
	else: nodes.icons.contact.set_modulate(Color(.2,.6,.8))
	
	if skill.levelData[0].EP > character.stats.EP:
		get_node("EP_Display/LevelLabel/MaxBar").value = 0
		self.set_opacity(0.5)
		self.set_disabled(true)
		return
	get_node("EP_Display/LevelLabel/MaxBar").value = float(character.stats.EP)/float(character.stats.MEP)
	levelSet(0)

func levelSet(lv):
	if lv > skill.levels:
		if character.stats.over >= skill.overCost: level = 8
		else: level = skill.levels
	elif lv < 0: level = 0
	else: level = lv
	
	var levelLabel = ""
	if level == 8: levelLabel = "OVER"
	else: levelLabel = str("Level ", level + 1, "(", skill.levels + 1, ")")

	nodes.labels.level.set_text(levelLabel)
	get_node("ADIcon").set(skill.levelData[level].AD, skill.levelData[level].absoluteAD)
	
	if skill.levelData[level].damage[0] > 0:
		nodes.icons.element1.show()
		nodes.labels.element1.set_text(str(skill.levelData[level].damage[1]))
	else: nodes.icons.element1.hide()
	
	if skill.levelData[level].damage[2] > 0:
		nodes.icons.element2.show()
		nodes.labels.element2.set_text(str(skill.levelData[level].damage[3]))
	else: nodes.icons.element2.hide()

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
	if level == 8: levelSet(skill.levels)
	else: levelSet(level - 1)

func _on_B_Increase_pressed():
	levelSet(level + 1)

func _on_SkillButton_pressed():
	self.emit_signal("skillChoice",slot, level)
