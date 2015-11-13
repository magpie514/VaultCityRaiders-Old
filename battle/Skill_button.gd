extends Button

signal skillChoice(slot, power)

const SOURCE_EP = 0
const SOURCE_VP = 1

const TYPE_EFFECT = 0
const TYPE_ENERGY = 1
const TYPE_KINETIC = 2
const TYPE_FIELD = 3 #NOTE:4 Should this be used, or a subform of EFFECT? @Data

const TARGET_SELF = 0
const TARGET_SINGLE = 1
const TARGET_ALL_ALLY = 2
const TARGET_ALL_ENEMY = 3

export var slot = 0 #NOTE:10 Have the interface just return slots. @Skill @Combat
export var debug = false

var power = 0
var powerMod = 0
var level = 0
var levelMax = 0
var epMax = 0
var speedIncrease = 0.0
var character = null
var skill = null

var nodes = {
	icons = { sType = null,	contact = null },
	labels = { level = null, EP = null },
	bars = { level = null },
}

var barColors = [	Color(.0, .0, .3),		Color(.0, .0, .6),		Color(.0, .0, .9),
					Color(.0, .3, 1.0),		Color(.0, .6, 1.0),		Color(.0, .9, 1.0),
					Color(.3, 1.0, 1.0),	Color(.6, 1.0, 1.0),	Color(.7, 1.0, 1.0)	]

var testaction = {
	name = "Debug Blaster",
	sType = TYPE_ENERGY,
	target = TARGET_SINGLE,
	contact = false,
	sRange = 3,
	elements = [0, 0],
	power_source = SOURCE_EP,
	levelMax = 5,
	levels = [10, 20, 30, 40, 50, 60, 70, 0, 0, 0, 0], #TODO:10 Make a pretty setter function (with sort, for safety) somewhere @Skill
}

var testchar = {
	stats = {
		EP = 500000,
		MEP = 500000,
		over = 100,
	}
}

static func levelCheck(power, levelMax, levelList):
	if power == levelList[levelMax]:
		return levelMax
	else:
		var ii = 0
		for i in range(0, levelMax + 1): #NOTE:128 Remember range() is always end+1
			if power >= levelList[i]:
				ii += 1
		return ii - 1

func _ready():
	if debug:
		init(testaction, testchar)
	nodes.labels.level = get_node("EP_Display/LevelLabel")
	nodes.labels.EP = get_node("EP_Display/EPLabel")
	nodes.bars.level = get_node("EP_Display/LevelLabel/Bar")

func _process(delta):
	if powerMod != 0:
		power += int(speedIncrease) * powerMod
		if power < skill.levels[0]:
			power = skill.levels[0]
			powerMod = 0
			self.set_process(false)
		if power > epMax:
			power = epMax
			powerMod = 0
			self.set_process(false)
	else:
		self.set_process(false)

	var levelLabel = ""
	level = levelCheck(power, levelMax, skill.levels)
	if level == levelMax:
		if character.stats.over == 100:
			levelLabel = "OVER"
		else:
			levelLabel = "EX"
	else:
		levelLabel = str(level + 1)

	if speedIncrease < 5.0:  #Start slow to allow single-digit changes with a quick click/tap, then speed up.
		speedIncrease += .15 + delta
	else:
		speedIncrease += delta * (epMax / 25.0)

	nodes.labels.level.set_text(str("Level ", levelLabel))
	nodes.labels.EP.set_text(str(power))
	nodes.bars.level.value = float(power)/float(epMax)
	nodes.bars.level.color = barColors[level]

#TODO:50 Find a way to make the last power level be remembered. @Combat @GUI +Brainstorm
func init(act, char):
	skill = act
	character = char
	get_node("NameLabel").set_text(act.name)
	if skill.sType == TYPE_ENERGY:
		get_node("TypeIcon").set_frame(0)
		get_node("TypeIcon").set_modulate(Color(.8,0,.8))
	elif skill.sType == TYPE_KINETIC:
		get_node("TypeIcon").set_frame(1)
		get_node("TypeIcon").set_modulate(Color(.4,.4,.4))
	elif skill.sType == TYPE_EFFECT:
		get_node("TypeIcon").set_frame(2)
		get_node("TypeIcon").set_modulate(Color(.4,.4,.8))
		
	if skill.contact:
		get_node("ContactIcon").set_frame(4)
		get_node("ContactIcon").set_modulate(Color(.6,.2,.2))
	else:
		get_node("ContactIcon").set_frame(5)
		get_node("ContactIcon").set_modulate(Color(.2,.6,.8))

	
	if skill.levels[0] > character.stats.EP:
		get_node("EP_Display/LevelLabel/MaxBar").value = 0
		self.set_opacity(0.5)
		self.set_disabled(true)
		self.set_process(false)
		get_node("EP_Display/LevelLabel").set_text("")
		get_node("EP_Display/EPLabel").set_text("")
		get_node("EP_Display/LevelLabel/Bar").value = 0
		get_node("B_Decrease").set_disabled(true)
		get_node("B_Increase").set_disabled(true)
		return
	else:
		power = skill.levels[0]

	if character.stats.over == 100:
		levelMax = skill.levelMax + 1
	else:
		levelMax = skill.levelMax
		
	if skill.levels[levelMax] < character.stats.EP:
		epMax = act.levels[levelMax]
	else:
		epMax = character.stats.EP

	get_node("EP_Display/LevelLabel/MaxBar").value = float(character.stats.EP)/float(epMax)
	self.set_process(true)

func _on_B_Decrease_pressed():
	powerMod = -1
	power -= 1
	speedIncrease = 0.0
	self.set_process(true)

func _on_B_Increase_pressed():
	powerMod = 1
	power += 1
	speedIncrease = 0.0
	self.set_process(true)

func _on_B_Increase_released():
	powerMod = 0

func _on_B_Decrease_released():
	powerMod = 0

func _on_SkillButton_pressed():
	self.emit_signal("skillChoice",slot, power)
