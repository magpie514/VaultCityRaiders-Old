extends Node

const SKILL_SOURCE_EP = 	0
const SKILL_SOURCE_VP = 	1

const SKILL_TYPE_COMBAT = 	0
const SKILL_TYPE_EFFECT = 	1

const ELEMENT_NONE =		0
const ELEMENT_KINETIC =		1
const ELEMENT_FIRE =		2
const ELEMENT_COLD =		3
const ELEMENT_GRAVITY =		4
const ELEMENT_OUTSIDER =	5

const TARGET_SELF = 		0
const TARGET_SINGLE = 		1
const TARGET_ALL_ALLY = 	2
const TARGET_ALL_ENEMY = 	3

var skillLib = {}

onready var nodes = {
	sfxPlayer = get_node("UI_SFX")
}

var debugp = preload("res://battle/debug/debugparty.gd").new()
var enemyp = preload("res://battle/debug/debugparty2.gd").new()

var battleData = {
	playerParty = null,
	enemyParty = null,
	background = "",
	bgm = "",
	boss = false,
}

func newArray(size):
	var a = []
	a.resize(size)
	return a

func battleStart(playerParty, enemyParty, background, bgm, boss):
	battleData.playerParty = playerParty
	battleData.enemyParty = enemyParty
	battleData.background = background
	battleData.bgm = bgm
	battleData.boss = boss
	get_tree().change_scene("res://battle/Battle.tscn")

class Char:
	var name = ""
	var race = 0
	var stats = { vital = 0, ep = 0, over = 0, ad = 0, lp = 0 }
	var statBase = {
		vital = 0, lp = 0, ep = 0,
		awakening = false,
		ad = 0,
		strength = 0, wisdom = 0, speed = 0,
	}
	var combatSkill = []
	var fieldSkill = []
	var passiveSkill = []

	func vitalCheck():
		if self.stats.vital > statBase.vital: self.stats.vital = statBase.vital
		elif self.stats.vital < 0: self.stats.vital = 0

func _init():
	var f = File.new()
	var buffer = ""
	if f.open("res://data/skill/default.json", File.READ) == 0:
		buffer = f.get_as_text()
		skillLib.parse_json(buffer)
		#print(skillLib)
		f.close()
		f = null
	else: print("res://data/skill/default.json not found!")

func _ready():
	pass

func sfxPlay(name):
	nodes.sfxPlayer.play(name)
