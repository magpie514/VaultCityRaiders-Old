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
var character = null
var skill = null
var epMax = 0
var tex_rects = [Rect2(0,0,20,20), Rect2(20,0,20,20), Rect2(0,20,20,20), Rect2(20,20,20,20)]
var increase_spd = 0.0

var testaction = {
	name = "Debug Blaster",
	sType = TYPE_ENERGY,
	target = TARGET_SINGLE,
	contact = false,
	sRange = 3,
	elements = [0, 0],
	power_source = SOURCE_EP,	#SOURCE_VP, SOURCE_EP
	levelMax = 5,
	levels = [10, 20, 30, 40, 50, 60, 70, 0, 0, 0, 0], #TODO:10 Make a pretty setter function (with sort, for safety) somewhere @Skill
}

var testchar = {
	EP = 500000,
	MEP = 500000,
	OD = false
}

static func levelCheck(power, levelMax, levelList):
	if power == levelList[levelMax]:
		return levelMax
	else:
		var ii = 0
		for i in range(0, levelMax):
			if power >= levelList[i]:
				ii += 1
		return ii - 1

func _ready():
	if debug:
		init(testaction, testchar)

func _process(delta):
	if powerMod != 0:
		power += int(increase_spd) * powerMod
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
		if character.OD:
			levelLabel = "EX"
		else:
			levelLabel = "OVER"
	else:
		levelLabel = str(level + 1)

	if increase_spd < 5.0:  #Start slow to allow single-digit changes with a quick click/tap, then speed up.
		increase_spd += .1
	else:
		increase_spd += delta * (epMax / 30.0)

	get_node("EP_Display/LevelLabel").set_text(str("Level ", levelLabel))
	get_node("EP_Display/EPLabel").set_text(str(power))
	get_node("EP_Display/LevelLabel/Bar").value = float(power)/float(epMax)

#TODO:50 Find a way to make the last power level be remembered. @Combat @GUI +Brainstorm
func init(act, char):
	var test = AtlasTexture.new()
	skill = act
	character = char
	get_node("NameLabel").set_text(act.name)
	if skill.sType == TYPE_ENERGY:
		get_node("TypeIcon").get_texture().set_region(tex_rects[1])
		get_node("TypeIcon").set_modulate(Color(.8,0,.8))
	elif skill.sType == TYPE_KINETIC:
		get_node("TypeIcon").get_texture().set_region(tex_rects[0])
		get_node("TypeIcon").set_modulate(Color(.4,.4,.4))
	elif skill.sType == TYPE_EFFECT:
		get_node("TypeIcon").get_texture().set_region(tex_rects[0])
		get_node("TypeIcon").set_modulate(Color(.4,.4,.8))
		
	if skill.contact:
		get_node("RangeIcon").get_texture().set_region(tex_rects[2])
		get_node("RangeIcon").set_modulate(Color(.6,.2,.2))
	else:
		get_node("RangeIcon").get_texture().set_region(tex_rects[3])
		get_node("RangeIcon").set_modulate(Color(.2,.6,.8))

	
	if skill.levels[0] > character.EP:
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

	if character.OD:
		levelMax = skill.levelMax + 1
	else:
		levelMax = skill.levelMax
		
	if skill.levels[levelMax] < character.EP:
		epMax = act.levels[levelMax]
	else:
		epMax = character.EP

	get_node("EP_Display/LevelLabel/MaxBar").value = float(character.EP)/float(epMax)
	self.set_process(true)

func _on_B_Decrease_pressed():
	powerMod = -1
	power -= 1
	increase_spd = 0.0
	self.set_process(true)

func _on_B_Increase_pressed():
	powerMod = 1
	power += 1
	increase_spd = 0.0
	self.set_process(true)

func _on_B_Increase_released():
	powerMod = 0

func _on_B_Decrease_released():
	powerMod = 0

func _on_SkillButton_pressed():
	self.emit_signal("skillChoice",slot, power)
