extends Button

signal attackChoice(slot, level)

export(int) var slot = 0
export(bool) var debug = false

var level = 0
var character = null
var weapon = null
#var testwpdef = {
#	name = "Debug Cannon",
#	wClass = WEAPONCLASS_CANNON,
#	description = "A test weapon",
#	effectColor = Color(0.7, 0.75, 1.0),
#	creator = 0,
#	dualWield = true,
#	durability = 9999,
#	ammoClass = AMMOCLASS_ENERGY, ammoCapacity = 32,
#	#TODO: Include weapon ammo source (ammo/user EP/weapon EP/user VP)
#	value = 99999,
#	survival = false,
#	STRreq = 1, WISreq = 1,
#
#	attack1 = {
#		name = "Linear Buster",
#		effect = "res://battle/effect/debug02.tscn",
#		levels = 0,
#		powerSource = main.SKILL_SOURCE_W_AMMO,
#		overCost = 25,
#		levelData = [
#			{
#				contact = false,
#				durability = 10,
#				ammo = 1,
#				AD = -1,
#				absoluteAD = false,
#				damage = [main.ELEMENT_LIGHT, 2500, main.ELEMENT_ELEC, 1000],
#				target = [0, 3, 2],
#				ACC = 100,
#				AGI = 0,
#				effect = null
#			},
#			null,
#			null,
#			null,
#			null,
#			null,
#			null,
#			null,
#			{
#				contact = false,
#				durability = 100,
#				ammo = 5,
#				AD = -10,
#				absoluteAD = false,
#				damage = [main.ELEMENT_LIGHT, 45000, main.ELEMENT_ELEC, 30000],
#				target = [0, 3, 4],
#				ACC = 100,
#				AGI = -10,
#				effect = null
#			},
#		]
#	},
#	attack2 = {
#		name = "Calamity Shower",
#		effect = "res://battle/effect/debug02.tscn",
#		levels = 0,
#		powerSource = main.SKILL_SOURCE_W_AMMO,
#		overCost = 25,
#		levelData = [
#			{
#				contact = false,
#				durability = 20,
#				ammo = 5,
#				AD = -1,
#				absoluteAD = false,
#				damage = [main.ELEMENT_LIGHT, 1500, main.ELEMENT_ELEC, 2000],
#				target = [0, 3, 4],
#				ACC = 90,
#				AGI = 5,
#				effect = null
#			},
#			null,
#			null,
#			null,
#			null,
#			null,
#			null,
#			null,
#			{
#				contact = false,
#				durability = 100,
#				ammo = 10,
#				AD = -10,
#				absoluteAD = false,
#				damage = [main.ELEMENT_LIGHT, 35000, main.ELEMENT_ELEC, 35000],
#				target = [0, 3, 6],
#				ACC = 95,
#				AGI = 10,
#				effect = null
#			},
#		]
#	},
#}


onready var nodes = {
	labels = {
		name = get_node("NameLabel"),
		level = get_node("Display/LevelLabel"),
		durability = get_node("Display/Durability"),
		ammo = get_node("Display/Ammo"),
	},
	bars = {
		durability = get_node("Display/Durability/ColorRampBar"),
		ammo = get_node("Display/Ammo/ColorRampBar"),
	},
}

var testchar = {	stats = {	EP = 99999999,	MEP = 99999999,	over = 100,	}		}

func _ready():
	#if debug:
	#	init(nodes.main.skillLib["none"], testchar)
	pass

func init(WP, char):
	weapon = WP
	character = testchar
	get_node("NameLabel").set_text(WP.name)

#	if skill.levelData[0].EP > character.stats.EP:
#		get_node("EP_Display/LevelLabel/MaxBar").value = 0
#		self.set_opacity(0.5)
#		self.set_disabled(true)
#		return
#	get_node("EP_Display/LevelLabel/MaxBar").value = float(character.stats.EP)/float(character.stats.MEP)
	levelSet(0)

func levelSet(lv):
	if lv > weapon.levels:
		if character.stats.over >= weapon.overCost: level = 8
		else: level = weapon.levels
	elif lv < 0: level = 0
	else: level = lv

	var levelLabel = ""
	if level == 8: levelLabel = "OVER"
	else: levelLabel = str("L.", level + 1, "/", weapon.levels + 1)
	nodes.labels.level.set_text(levelLabel)

	if level == 8: nodes.labels.level.set_text(str("L.OVER"))
	else: nodes.labels.level.set_text(str("L.", level + 1, "/", weapon.levels + 1))

	get_node("SkillData").init(weapon.levelData[level])
	nodes.labels.durability.set_text(str("Durability: ", weapon.levelData[level].durability))
	nodes.bars.durability.value = float(weapon.levelData[level].durability)/float(100)
	nodes.labels.ammo.set_text(str("Ammo: ", weapon.levelData[level].ammo))
	nodes.bars.ammo.value = float(weapon.levelData[level].ammo)/float(32)

func _on_B_Decrease_pressed():
	if level == 8: levelSet(weapon.levels)
	else: levelSet(level - 1)

func _on_B_Increase_pressed():
	levelSet(level + 1)

func _on_WeaponButton_pressed():
	self.emit_signal("attackChoice",slot, level)
