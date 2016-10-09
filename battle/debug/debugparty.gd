extends Node
var party = {
	init = false,
	formation = [ 0, 5, 2, 3, 1, null ],
	character = [
		{
			name = "Shiro",
			status = 0,
			npc = false,
			stats = { V = 75000, EP = 9999999, AD = 120, over = 100, AGImod = 1.0 }, battleData = {} ,
			baseStats = { V = 75000, EP = 9999999, AD = 120, awakening = true, STR = 65, WIS = 50, AGI = 35 },
			specialData = {
				weapon = "res://data/char/shiro/weapon.json", weaponDef = null,
				skill = "res://data/char/shiro/skill.json", skillDef = null,
			},
			equip = {
				weapon = [	{tag = "@GANREI", def = null, customname = "", durability = 9500, capacity = 5},
							{tag = "@KOKUKO", def = null, customname = "", durability = 0, capacity = 32},],
				armor = null,
			},
			charscn = "res://data/char/shiro/shiro01.tscn",
			skills = [
				{ID = "shiro01",	lastLevel = 0 },	 {ID = "shiro02",	lastLevel = 0 },
				{ID = "shiro03",	lastLevel = 0 },	 {ID = "shiro04",	lastLevel = 0 },
			]
		},{
			name = "Magpie",
			status = 0,
			npc = false,
			stats = { V = 54000, EP = 999999, AD = 105, over = 0, AGImod = 1.0 }, battleData = {} ,
			baseStats = { V = 54000, EP = 999999, AD = 105, awakening = false, STR = 40, WIS = 80, AGI = 65 },
			specialData = null,
			equip = {
				weapon = [	{tag = "DEBCAN", def = null, customname = "", durability = 9500, capacity = 5},
							{tag = "DEBCAN", def = null, customname = "", durability = 100, capacity = 32},],
				armor = null,
			},
			charscn = "res://data/char/magpie/magpie01.tscn",
			skills = [
				{ID = "magpie01",	lastLevel = 0 },	{ID = "magpie02",	lastLevel = 0 },
				{ID = "magpie03",	lastLevel = 0 },	{ID = "magpie04",	lastLevel = 0 },
			]
		},{
			name = "Jay",
			status = 0,
			npc = false,
			stats = { V = 60000, EP = 9999999, AD = 105, over = 99, AGImod = 1.0 }, battleData = {} ,
			baseStats = { V = 60000, EP = 9999999, AD = 105, awakening = true, STR = 70, WIS = 65, AGI = 95 },
			specialData = {
				weapon = "res://data/char/jay/weapon.json", weaponDef = null,
				skill = "res://data/char/jay/skill.json", skillDef = null,
			},
			equip = {
				weapon = [	{tag = "@ORBRIF", def = null, customname = "", durability = 9500, capacity = 5},
							{tag = "DEBCAN", def = null, customname = "", durability = 100, capacity = 32},],
				sidearm = null,
				armor = null,
			},
			charscn = "res://data/char/jay/jay01.tscn",
			skills = [
				{ID = "jay01",	lastLevel = 0 },		{ID = "jay02",	lastLevel = 0 },
				{ID = "jay03",	lastLevel = 0 },		{ID = "jay04",	lastLevel = 0 },
			]
		},
		{
			name = "Yukiko",
			status = 0,
			npc = false,
			stats = { V = 45000, EP = 9999999, AD = 100, over = 20, AGImod = 1.0 }, battleData = {} ,
			baseStats = { V = 45000, EP = 9999999, AD = 100, awakening = false, STR = 5, WIS = 100, AGI = 50 },
			specialData = {
				weapon = "res://data/char/yukiko/weapon.json", weaponDef = null,
				skill = "res://data/char/yukiko/skill.json", skillDef = null,
			},
			equip = {
				weapon = [	{tag = "@SNOLEF", def = null, customname = "", durability = 9500, capacity = 5},
							{tag = "DEBCAN", def = null, customname = "", durability = 100, capacity = 32},],
				sidearm = null,
				armor = null,
			},
			charscn = "res://data/char/yukiko/yukiko.tscn",
			skills = [
				{ID = "shiro01",	lastLevel = 0 },	{ID = "shiro02",	lastLevel = 0 },
				{ID = "shiro03",	lastLevel = 0 },	{ID = "shiro04",	lastLevel = 0 },
			]
		},
		{
			name = "Test02",
			status = 0,
			npc = false,
			stats = { V = 32500, EP = 4999999, AD = 100, over = 80, AGImod = 1.0 }, battleData = {} ,
			baseStats = { V = 75000, EP = 99999999, AD = 110, awakening = true, STR = 100, WIS = 5, AGI = 50 },
			specialData = null,
			equip = {
				weapon = [	{tag = "DEBCAN", def = null, customname = "", durability = 9500, capacity = 5},
							{tag = "DEBCAN", def = null, customname = "", durability = 100, capacity = 32},],
				sidearm = null,
				armor = null,
			},
			charscn = null,
			skills = [
				{ID = "shiro01",	lastLevel = 0 },	{ID = "shiro02",	lastLevel = 0 },
				{ID = "shiro03",	lastLevel = 0 },	{ID = "shiro04",	lastLevel = 0 },
			]
		},
		{
			name = "René",
			status = 0,
			npc = true,
			stats = { V = 45000, EP = 9999999, over = 50, AD = 110, AGImod = 1.0 }, battleData = {} ,
			baseStats = { V = 45000, EP = 9999999, AD = 110, awakening = false, STR = 60, WIS = 40, AGI = 72 },
			specialData = null,
			equip = {
				weapon = [	{tag = "DEBCAN", def = null, customname = "", durability = 9500, capacity = 5},
							{tag = "DEBCAN", def = null, customname = "", durability = 100, capacity = 32},],
				sidearm = null,
				armor = null,
			},
			charscn = "res://data/char/rene/rene01.tscn",
			skills = [
				{ID = "rene01",	lastLevel = 0 },	{ID = "rene02",	lastLevel = 0 },
				{ID = "rene03",	lastLevel = 0 },	{ID = "rene04",	lastLevel = 0 },
			]
		}
	]
}
