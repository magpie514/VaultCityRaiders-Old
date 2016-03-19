extends Node

const SKILL_SOURCE_EP = 0
const SKILL_SOURCE_VP = 1

const SKILL_TYPE_COMBAT = 0
const SKILL_TYPE_EFFECT = 1

const ELEMENT_NONE =			0
const ELEMENT_KINETIC =		1
const ELEMENT_FIRE =			2
const ELEMENT_COLD =			3
const ELEMENT_GRAVITY =		4
const ELEMENT_OUTSIDER =	5

const TARGET_SELF = 0
const TARGET_SINGLE = 1
const TARGET_ALL_ALLY = 2
const TARGET_ALL_ENEMY = 3

var skillLib = {}

class Char:
	var name = ""
	var race = 0
	var stats = {	vital = 0, ep = 0, over = 0, ad = 0, lp = 0, }
	var statBase = {
		vital = 0, lp = 0, ep = 0,
		awakening = false,
		ad = 0,
		strength = 0, wisdom = 0, speed = 0,
	}
	

	var combatSkill = []
	var fieldSkill = []
	var passiveSkill = []

	#TODO: Ask on IRC if setget functions declared inside a class are stored inside the class. Just in case.
	func vitalCheck():
		if self.stats.vital > statBase.vital: self.stats.vital = statBase.vital
		elif self.stats.vital < 0: self.stats.vital = 0

func _init():
	var f = File.new()
	if f.open("res://data/skill/default.json", File.READ) == 0:
		skillLib = f.get_as_text()
		print(skillLib)
		f.close()
		f = null
	else:	print("res://data/skill/default.json not found!", f.open("res://data/skill/default.json", File.READ))

func _ready():
	#print(var2bytes(int(0))[0], var2bytes(-0)[0])
	pass
