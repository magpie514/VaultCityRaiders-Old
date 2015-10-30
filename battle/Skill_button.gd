extends Button

export var slot = 0 #NOTE:10 Let's store the skill values/pointers/everything in the character, and have the interface merely return the slot it's used at. @Skill @Combat
export var debug = false
const SOURCE_EP = 0
const SOURCE_VP = 1

signal skillChoice(slot, power)

#TODO:40 Decide action format. @Character +Brainstorm
var testaction = {
	name = "Debug Blaster",
	energy = true,	#false = kinetic, true = energy
	melee = false, 	#false = ranged, true = melee
	element = 0, #TODO:60 Decide the element list! @Skill @Character +Brainstorm
	element_secondary = false,
	element2 = 0,
	power_source = 0,	#SOURCE_VP, SOURCE_EP
	levelMax = 5,
	target = 0, #TODO:45 Define range as a small grid of 5x2.
	levels = [50, 100, 200, 400, 800, 1600, 3200, 0, 0, 0, 0], #TODO:10 Make a pretty setter function (with sort, for safety) somewhere @Skill
}

var testchar = {
	EP = 500000,
	MEP = 500000,
	OD = false
}

var power = 0
var powerMod = 0
var level = 0
var levelMax = 0
var character = null
var skill = null
var epMax = 0
var epMin = 0
var tex_rects = [Rect2(0,0,20,20), Rect2(20,0,20,20), Rect2(0,20,20,20), Rect2(20,20,20,20)]
var increase_spd = 0

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
		if power < epMin:
			power = epMin
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
			levelLabel = "MAX"
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
	if skill.energy:
		get_node("TypeIcon").get_texture().set_region(tex_rects[1])
		get_node("TypeIcon").set_modulate(Color(.8,0,.8))
	else:
		get_node("TypeIcon").get_texture().set_region(tex_rects[0])
		get_node("TypeIcon").set_modulate(Color(.4,.4,.4))
	if skill.melee:
		get_node("RangeIcon").get_texture().set_region(tex_rects[2])
		get_node("RangeIcon").set_modulate(Color(.6,.2,.2))
	else:
		get_node("RangeIcon").get_texture().set_region(tex_rects[3])
		get_node("RangeIcon").set_modulate(Color(.2,.6,.8))

	epMin = skill.levels[0]
	if epMin > character.EP:
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
		power = epMin

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
