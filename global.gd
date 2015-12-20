extends Node

var skillLib = {}

const SKILL_SOURCE_EP = 0
const SKILL_SOURCE_VP = 1

const SKILL_TYPE_EFFECT = 0
const SKILL_TYPE_ENERGY = 1
const SKILL_TYPE_KINETIC = 2

const ELEMENT_NONE =			0
const ELEMENT_NORMAL =		1
const ELEMENT_FIRE =			2
const ELEMENT_GRAVITY =		3
const ELEMENT_OUTSIDER =	4

const TARGET_SELF = 0
const TARGET_SINGLE = 1
const TARGET_ALL_ALLY = 2
const TARGET_ALL_ENEMY = 3

func _ready():
	skillLib["none"] = {
		name = "Debug Blast",
		effect = "res://battle/effect/debug01.xscn",
		levels = 2,
		powerSource = SKILL_SOURCE_EP,
		contact = false,
		sType = SKILL_TYPE_ENERGY,
		overCost = 1,
		levelData = [
			{
				EP = 200,
				AD = -999,
				absoluteAD = false,
				damage = [1, 20,		0, 0],
				hitRange = 1,
				accuracy = 90,
				effect = null
			},{
				EP = 1000,
				AD = 999,
				absoluteAD = false,
				damage = [1, 90,		1, 10],
				hitRange = 1,
				accuracy = 100,
				effect = "paralysis (30%)"
			},
			{
				EP = 2000,
				AD = 100,
				absoluteAD = true,
				damage = [1, 300,		1, 50],
				hitRange = 1,
				accuracy = 100,
				effect = "paralysis (50%)"
			},
			{
				EP = 3000,
				AD = 0,
				absoluteAD = false,
				damage = [1, 350,		1, 200],
				hitRange = 1,
				accuracy = 100,
				effect = "paralysis (100%)"
			},
			null,
			null,
			null,
			null,
			null,
			null,
		]
	}
	skillLib["gcrfield"] = {
		name = "Debug Blast",
		effect = "res://battle/effect/GCrystalField/effect.xscn",
		levels = 2,
		powerSource = SKILL_SOURCE_EP,
		contact = false,
		sType = SKILL_TYPE_ENERGY,
		overCost = 1,
		levelData = [
			{
				EP = 200,
				AD = -999,
				absoluteAD = false,
				damage = [1, 20,		0, 0],
				hitRange = 1,
				accuracy = 90,
				effect = null
			},{
				EP = 1000,
				AD = 999,
				absoluteAD = false,
				damage = [1, 90,		1, 10],
				hitRange = 1,
				accuracy = 100,
				effect = "paralysis (30%)"
			},
			{
				EP = 2000,
				AD = 100,
				absoluteAD = true,
				damage = [1, 300,		1, 50],
				hitRange = 1,
				accuracy = 100,
				effect = "paralysis (50%)"
			},
			{
				EP = 3000,
				AD = 0,
				absoluteAD = false,
				damage = [1, 350,		1, 200],
				hitRange = 1,
				accuracy = 100,
				effect = "paralysis (100%)"
			},
			null,
			null,
			null,
			null,
			null,
			null,
		]
	}
