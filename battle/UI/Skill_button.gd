extends Button

signal skillChoice(slot, power)

export(int) var slot = 0
export(bool) var debug = false

var level = 0
var character = null
var skill = null

onready var nodes = {
	labels = {
		name = get_node("NameLabel"),
		level = get_node("EP_Display/LevelLabel"),
		EP = get_node("EP_Display/EPLabel"),
	},
	bars = { level = get_node("EP_Display/LevelLabel/ColorRampBar") },
}

var testchar = {	stats = {	EP = 99999999,	MEP = 99999999,	over = 100,	}		}

func _ready():
	#if debug:
	#	init(nodes.main.skillLib["none"], testchar)
	pass

func init(act, char):
	skill = act
	character = char
	nodes.labels.name.set_text(act.name)

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
	else: levelLabel = str("Level ", level + 1, "/", skill.levels + 1)

	nodes.labels.level.set_text(levelLabel)
	get_node("SkillData").init(skill.levelData[level])
	nodes.labels.EP.set_text(str(skill.levelData[level].EP))
	nodes.bars.level.value = float(skill.levelData[level].EP)/float(character.stats.MEP)

func _on_B_Decrease_pressed():
	if level == 8: levelSet(skill.levels)
	else: levelSet(level - 1)

func _on_B_Increase_pressed():
	levelSet(level + 1)

func _on_SkillButton_pressed():
	self.emit_signal("skillChoice",slot, level)
