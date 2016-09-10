extends Node
var party = {
	init = false,
	formation = [ 0, 5, 2, null, 1, null ],
	character = [
		{
			name = "Shiro",
			status = 0,
			npc = false,
			stats = {
				V = 75000,
				EP = 9999999,
				AD = 110,
				over = 100,
				STR = 65, WIS = 50, AGI = 35,
			},
			baseStats = {
				V = 75000, EP = 99999999,
				AD = 110, awakening = true,
			},
			equip = {
				weapon = [	{tag = "DEBCAN", def = null, customname = "", durability = 9500, capacity = 5},
							{tag = "DEBCAN", def = null, customname = "", durability = 0, capacity = 32},],
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
			stats = {
				V = 12000, EP = 999999,
				AD = 100, over = 50,
				STR = 40, WIS = 80, AGI = 65,
			},
			baseStats = {
				V = 54000, EP = 999999,
				AD = 110, awakening = false,
			},
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
			stats = {
				V = 50000, EP = 99999999,
				AD = 105, over = 99,
				STR = 70, WIS = 65, AGI = 95,
			},
			baseStats = {
				V = 50000, EP = 99999999,
				AD = 105, awakening = true,
			},
			equip = {
				weapon = [	{tag = "DEBCAN", def = null, customname = "", durability = 9500, capacity = 5},
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
			name = "Test01",
			status = 0,
			npc = false,
			stats = {
				V = 65000, EP = 2999,
				AD = 90, over = 20,
				STR = 5, WIS = 100, AGI = 50,
			},
			baseStats = {
				V = 75000, EP = 99999999,
				AD = 110, awakening = true,
			},
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
			name = "Test02",
			status = 0,
			npc = false,
			stats = {
				V = 32500, EP = 4999999,
				AD = 100, over = 80,
				STR = 100, WIS = 5, AGI = 50,
			},
			baseStats = {
				V = 75000, EP = 99999999,
				AD = 110, awakening = true,
			},
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
			stats = {
				V = 40000, EP = 9999999,
				over = 50, AD = 120, baseAD = 120,
				STR = 60, WIS = 40, AGI = 72,
			},
			baseStats = {
				V = 45000, EP = 99999999,
				AD = 120, awakening = false,
			},
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
