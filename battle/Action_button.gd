extends Button

export var result = 0 #NOTE:10 Let's store the skill values/pointers/everything in the character, and have the interface merely return the slot it's used at. @Skill @Combat
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
	levelMax = 7, #NOTE:1 levels 0-8 (1-9 in-game), level EX. Level ∞
	levels = [50, 100, 200, 400, 800, 1600, 3200, 0, 0, 0, 0], #TODO:10 Make a pretty setter function (with sort, for safety) somewhere @Skill
}

var testchar = {
	EP = 500000,
	MEP = 500000,
	OD = false
}

var power = 0
var powermod = 0
var level = 0
var levelMax = 0
var character = null
var skill = null
var epMax = 0
var tex_rects = [Rect2(0,0,20,20), Rect2(20,0,20,20), Rect2(0,20,20,20), Rect2(20,20,20,20)]
var increase_spd = 0

func _ready():
	self.set_process(true)
	init(testaction, testchar)

func _process(delta):
	#FIXME:6 This is all sorts of messed up. Make it so 0-(lv.1 EP) is lv.0, and (levelMax EP) is "lv.EX", and if not in over mode, (levelMax-1 EP) is "lv.MAX"
	if powermod != 0:
		power += int(increase_spd) * powermod
		if power < 0:
			power = 0
			powermod = 0
		if power > epMax:
			power = epMax
			powermod = 0
	else:
		self.set_process(true)

	print(str(power, "/", skill.levels[level]))
	if power >= skill.levels[level] and level < levelMax:
		level += 1
	elif level > 0 and power < skill.levels[level - 1]:
		level -= 1


	if increase_spd < 5:  #Start slow to allow single-digit changes with a quick click/tap, then speed up.
		increase_spd += 0.1
	else:
		increase_spd += delta * (epMax / 60)

	get_node("EP_Display/LevelLabel").set_text(str("Level ", level))
	get_node("EP_Display/EPLabel").set_text(str(power))
	get_node("EP_Display/LevelLabel/Bar").value = float(power)/float(epMax)


#TODO:50 Find a way to make the last power level be remembered. @Combat @GUI +Brainstorm
func init(act, char):
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
	
	if character.OD:
		levelMax = skill.levelMax
	else:
		levelMax = skill.levelMax - 1
		
	if skill.levels[levelMax] < character.EP:
		epMax = act.levels[levelMax]
	else:
		epMax = character.EP
	get_node("EP_Display/LevelLabel/MaxBar").value = float(character.EP)/float(epMax)

func _on_B_Decrease_pressed():
	powermod = -1
	power -= 1
	increase_spd = 0

func _on_B_Increase_pressed():
	powermod = 1
	power += 1
	increase_spd = 0

func _on_B_Increase_released():
	powermod = 0

func _on_B_Decrease_released():
	powermod = 0

func _on_SkillButton_pressed():
	print(result, "+", power)
