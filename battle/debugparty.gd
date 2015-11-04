extends Node

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

var party = [
	{
		name = "Koishi",
		status = "OK",
		V = 9999,
		MV = 9999,
		EP = 99999999,
		MEP = 99999999,
		over = 99,
		OD = false,
		skills = [
			{
				name = "Youkai Polygraph",
				sType = TYPE_EFFECT,
				target = TARGET_SINGLE,
				contact = false,
				sRange = 4,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 1,
				levels = [50, 100, 200, 0, 0, 0, 0, 0, 0, 0, 0],
			},{
				name = "Embers of Love",
				sType = TYPE_ENERGY,
				target = TARGET_SINGLE,
				contact = false,
				sRange = 3,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 2,
				levels = [1000, 10000, 100000, 1000000, 0, 0, 0, 0, 0, 0, 0],
			},{
				name = "Release of the Id",
				sType = TYPE_EFFECT,
				target = TARGET_SELF,
				contact = false,
				sRange = 0,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 3,
				levels = [50000, 80000, 160000, 320000, 640000, 0, 0, 0, 0, 0, 0],
			},{
				name = "Subterranean Rose",
				sType = TYPE_ENERGY,
				target = TARGET_ALL_ENEMY,
				contact = false,
				sRange = 4,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 0,
				levels = [100000, 200000, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			}
		]
	},{
		name = "Magpie",
		status = "burn",
		V = 5400,
		MV = 5400,
		EP = 999999,
		MEP = 999999,
		over = 50,
		OD = false,
		skills = [
			{
				name = "G-Crystal Field",
				sType = TYPE_EFFECT,
				target = TARGET_SINGLE,
				contact = false,
				sRange = 3,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 5,
				levels = [2500, 8000, 20000, 50000, 90000, 200000, 999999, 0, 0, 0, 0],
			},{
				name = "Graviton Pulse",
				sType = TYPE_ENERGY,
				target = TARGET_SINGLE,
				contact = false,
				sRange = 3,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 2,
				levels = [15000, 30000, 100000, 200000, 0, 0, 0, 0, 0, 0, 0],
			},{
				name = "Dimensional Gear",
				sType = TYPE_EFFECT,
				target = TARGET_SELF,
				contact = false,
				sRange = 0,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 7,
				levels = [1000, 2000, 3500, 5000, 8000, 16000, 64000, 100000, 800000, 0, 0],
			},{
				name = "Spatial Rupture",
				sType = TYPE_ENERGY,
				target = TARGET_SINGLE,
				contact = false,
				sRange = 4,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 5,
				levels = [1000, 1100, 1200, 1400, 1800, 11600, 13200, 0, 0, 0, 0],
			}
		]
	},{
		name = "Kirarin",
		status = "OK",
		V = 9999,
		MV = 9999,
		EP = 10000,
		MEP = 10000,
		over = 99,
		OD = false,
		skills = [
			{
				name = "Kirarin Attack",
				sType = TYPE_KINETIC,
				target = TARGET_SINGLE,
				contact = true,
				sRange = 1,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 5,
				levels = [50, 100, 200, 400, 800, 1600, 3200, 0, 0, 0, 0],
			},{
				name = "Kirarin Voice",
				sType = TYPE_EFFECT,
				target = TARGET_ALL_ALLY,
				contact = false,
				sRange = 1,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 5,
				levels = [50, 100, 200, 400, 800, 1600, 3200, 0, 0, 0, 0],
			},{
				name = "Kirarin Dance",
				sType = TYPE_EFFECT,
				target = TARGET_SINGLE,
				contact = false,
				sRange = 1,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 5,
				levels = [50, 100, 200, 400, 800, 1600, 3200, 0, 0, 0, 0],
			},{
				name = "Kirarin Beam",
				sType = TYPE_ENERGY,
				target = TARGET_SINGLE,
				contact = false,
				sRange = 2,
				elements = [0, 0],
				power_source = SOURCE_EP,
				levelMax = 5,
				levels = [50, 100, 200, 400, 800, 1600, 3200, 0, 0, 0, 0],
			}
		]
	},
	null,
	null,
	null,
	{
		name = "Gooby",
		status = "OK",
		V = 99999,
		MV = 99999,
		EP = 99999,
		MEP = 99999,
		over = 50,
	},{
		name = "G-SLAVE bit",
		status = "OK",
		V = 1000,
		MV = 9999,
		EP = 1999,
		MEP = 9999,
		over = 0,
	}
]
