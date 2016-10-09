extends Node

const SKILL_SOURCE_NONE =	 	0
const SKILL_SOURCE_USER_EP = 	1
const SKILL_SOURCE_USER_VP = 	2
const SKILL_SOURCE_W_AMMO = 	3
const SKILL_SOURCE_W_EP = 		4

const ELEMENT_NONE =		0
const ELEMENT_KINETIC =		1
const ELEMENT_FIRE =		2
const ELEMENT_COLD =		3
const ELEMENT_ELEC = 		4
const ELEMENT_LIGHT = 		5
const ELEMENT_DARK = 		6
const ELEMENT_GRAVITY =		7
const ELEMENT_OUTSIDER =	8
const ELEMENT_SPIRIT =		9

const TARGET_SIDE_ENEMY =	0
const TARGET_SIDE_OWN =		1
const TARGET_SIDE_ALL = 	2

const TARGET_SELF =			0
const TARGET_SINGLE =		1
const TARGET_VLINE =		2
const TARGET_HLINE =		3
const TARGET_CONE = 		4
const TARGET_ALL =			5

const BATTLE_ACTION_WEAPON = 	0
const BATTLE_ACTION_SKILL = 	1
const BATTLE_ACTION_DEFEND =	2
const BATTLE_ACTION_ITEM = 		3

const BATTLE_DEFEND_AGI_BONUS = 2000

const CHAR_STATUS_OK =			0
const CHAR_STATUS_DOWN = 		1

const elementData = {
	ELEMENT_NONE : 		{ icon = null, color = Color(0.1, 0.1, 0.1), name = null },
	ELEMENT_KINETIC : 	{ icon = null, color = Color(0.3, 0.3, 0.3), name = "kinetic" },
	ELEMENT_FIRE : 		{ icon = null, color = Color(0.7, 0.2, 0.0), name = "fire" },
	ELEMENT_COLD : 		{ icon = null, color = Color(0.4, 0.4, 0.8), name = "cold" },
	ELEMENT_ELEC : 		{ icon = null, color = Color(0.0, 0.4, 0.7), name = "electric" },
	ELEMENT_LIGHT : 	{ icon = null, color = Color(0.66, 0.66, 0.6), name = "light" },
	ELEMENT_DARK : 		{ icon = null, color = Color(0.1, 0.1, 0.1), name = "dark" },
	ELEMENT_GRAVITY : 	{ icon = null, color = Color(0.2, 0.0, 0.5), name = "gravity" },
	ELEMENT_SPIRIT : 	{ icon = null, color = Color(0.2, 0.4, 0.5), name = "spirit" },
	ELEMENT_OUTSIDER : 	{ icon = null, color = Color(0.75, 0.75, 0.1), name = "???" },
}

var skillDef = {}; var skillDefMods = {}
var weaponDef = {}; var weaponDefMods = {}

func elementColor(i): return elementData[i].color

onready var nodes = { sfxPlayer = get_node("UI_SFX") }

var debugp = preload("res://battle/debug/debugparty.gd").new()
var enemyDef = {}
var data = load("res://system/data.gd").new()

var battleData = {
	playerParty = null, enemyParty = null,
	background = "", bgm = "",
	boss = false,
}

static func newArray(size):
	var a = []; a.resize(size); return a

static func loadJSON(file):
	var dict = {}; var buffer = ""; var f = File.new()
	if f.open(file, File.READ) == 0:
		buffer = f.get_as_text()
		dict.parse_json(buffer)
		f.close()
	else: print("[!]",file, " not found!")
	f = null; buffer = null
	return dict


func rangeResolve(si, fo, ra, sl):
	var result = [[0,0,0],[0,0,0]]
	#Some special cases are checked first for optimization:
	if sl > 2 and ra < 2:
		#if in the back row, attacks with range under 2 will not hit anything.
		result = [[0,0,0],[0,0,0]]
	elif ((sl < 3 and ra >= 4) or (ra >= 6)):
		#if in the front row, range >= 4 will hit everything. range = 6 will hit everything.
		result = [[1,1,1],[1,1,1]]
	else:
		var colmod = clamp(floor(sl/3), 0, 1) #take one off if user is in back line.
		var colrng = clamp(floor(ra/2) - colmod, -1, 1) #Column range.
		var rowmod = sl % 3 #Define "front" position horizontally (either top, middle, bottom)
		var rowrng = 0
		for i in range(0, colrng + 1):
			rowrng = clamp(ra - ((colmod + i)*2), 0, 2)
			result[i][rowmod] = 1
			if rowrng > 0:
				for j in range(1, rowrng + 1):
					if rowmod+j <= 2: result[i][rowmod+j] = 1
					if rowmod-j >= 0: result[i][rowmod-j] = 1
	#TODO: Add v-line, h-line, cone formations.
	return result

func battleStart(playerParty, enemyParty, background, bgm, boss):
	battleData.playerParty = playerParty; battleData.enemyParty = enemyParty
	battleData.background = background; battleData.bgm = bgm
	battleData.boss = boss
	get_tree().change_scene("res://battle/Battle.tscn")

class Char:
	var data = {}



func weaponInit(C, WT): #weaponInit(Char C, string WT)
	if WT == null: return null
	else:
		var s = WT.left(1)
		if s == "@":
			if C.specialData != null:
				if C.specialData.weaponDef != null: return C.specialData.weaponDef[WT]
			else: return null
		elif s == ":":
			return weaponDefMods[WT]
		else:
			return weaponDef[WT]

func enemyWeaponInit(WP):
	var D = weaponDef[WP]
	return {
		tag = WP, def = D,
		customname = "",
		durability = D.durability,
		capacity = D.ammoCapacity,
	}

func enemyInit(D):
	var C = {
		name = D.name,
		status = CHAR_STATUS_OK,
		charscn = D.charscn,
		baseStats = Dictionary(D.baseStats),
		specialData = Dictionary(D.specialData) if D.specialData else null,
		stats = {V = D.baseStats.V, EP = D.baseStats.EP, AD = D.baseStats.AD, over = 0, AGImod = 1.0 },
		equip = {
			weapon = [enemyWeaponInit(D.equip.weapon[0]), enemyWeaponInit(D.equip.weapon[1])],
			armor = null,
		},
		skill = [null, null, null, null],
	}
	return C

func partyBlank():
	return {
		init = false,
		formation = [null, null, null, null, null, null],
		character = [null, null, null, null, null, null],
	}

func enemyPartyGenerate(F):
	print("[I] Generating enemy party formation: ", F)
	var P = partyBlank()
	for i in range(0, 6):
		if F[i] == null:
			P.formation[i] = null; P.character[i] = null
		else:
			P.formation[i] = i
			P.character[i] = enemyInit(enemyDef[F[i]])
	P.init = true
	return P




func _init():
	skillDef = loadJSON("res://data/skill/default.json");
	weaponDef = loadJSON("res://data/weapon/default.json");
	var tempEnemyDefs = preload("res://battle/debug/debugparty2.gd").new()
	enemyDef = Dictionary(tempEnemyDefs.enemyDef)
	data.validateWeaponDef(weaponDef)
	data.validateSkillDef(skillDef)
# TODO: This thing can be used to load mod weapons or special character weapons. Keep it for later.
#	var weaponDef2 = loadJSON("res://data/weapon/default1.json")
#	for key in weaponDef2:
#		weaponDef[key] = Dictionary(weaponDef2[key])
#	weaponDef2 = null
#	print(weaponDef)

func sfxPlay(name):
	nodes.sfxPlayer.play(name)

func bgmPlay(file):
	var bgm = load(file)
	get_node("StreamPlayer").set_stream(bgm)
	get_node("StreamPlayer").set_loop(true)
	get_node("StreamPlayer").play()

func bgmInit(B):
	if not B:
		print("[!] No BGM specified for battle.")
		bgmPlay("res://music/EOIV_Storm.ogg")
		#bgmPlay("res://music/ZTD_BGM37.ogg")
	else:
		bgmPlay(B)
