extends Node

var party = [
	{
		name = "Shiro",
		status = "OK",
		npc = false,
		stats = {
			V = 75000,
			MV = 75000,
			EP = 9999999,
			MEP = 9999999,
			AD = 110,
			over = 100,
			awakening = true,
		},
		charscn = "res://data/char/shiro/shiro01.tscn",
		skills = [
			{	ID = "shiro01",	lastLevel = 0 },
			{	ID = "shiro02",	lastLevel = 0 },
			{	ID = "shiro03",	lastLevel = 0 },
			{	ID = "shiro04",	lastLevel = 0 },
		]
	},{
		name = "Magpie",
		status = "OK",
		npc = false,
		stats = {
			V = 12000,
			MV = 54000,
			EP = 999999,
			MEP = 999999,
			AD = 100,
			over = 50,
			awakening = false,
		},
		charscn = "res://data/char/magpie/magpie01.tscn",
		skills = [
			{	ID = "magpie01",	lastLevel = 0 },
			{	ID = "magpie02",	lastLevel = 0 },
			{	ID = "magpie03",	lastLevel = 0 },
			{	ID = "magpie04",	lastLevel = 0 },
		]
	},{
		name = "Jay",
		status = "OK",
		npc = false,
		stats = {
			V = 50000,
			MV = 50000,
			EP = 99999999,
			MEP = 99999999,
			AD = 105,
			over = 99,
			awakening = true,
		},
		charscn = "res://data/char/jay/jay01.tscn",
		skills = [
			{	ID = "jay01",	lastLevel = 0 },
			{	ID = "jay02",	lastLevel = 0 },
			{	ID = "jay03",	lastLevel = 0 },
			{	ID = "jay04",	lastLevel = 0 },
		]
	},
	{
		name = "Test01",
		status = "OK",
		npc = false,
		stats = {
			V = 65000,
			MV = 75000,
			EP = 2999,
			MEP = 9999999,
			AD = 90,
			over = 20,
			awakening = true,
		},
		charscn = null,
		skills = [
			{	ID = "shiro01",	lastLevel = 0 },
			{	ID = "shiro02",	lastLevel = 0 },
			{	ID = "shiro03",	lastLevel = 0 },
			{	ID = "shiro04",	lastLevel = 0 },
		]
	},
	{
		name = "Test02",
		status = "OK",
		npc = false,
		stats = {
			V = 32500,
			MV = 75000,
			EP = 4999999,
			MEP = 9999999,
			AD = 100,
			over = 80,
			awakening = true,
		},
		charscn = null,
		skills = [
			{	ID = "shiro01",	lastLevel = 0 },
			{	ID = "shiro02",	lastLevel = 0 },
			{	ID = "shiro03",	lastLevel = 0 },
			{	ID = "shiro04",	lastLevel = 0 },
		]
	},
	{
		name = "Gooby",
		status = "OK",
		npc = true,
		stats = {
			V = 99999,
			MV = 99999,
			EP = 99999,
			MEP = 99999,
			over = 50,
			AD = 120,
			awakening = false,
		},
		charscn = null,
		skills = [
			{	ID = "m_gooby01",	lastLevel = 0 },
			{	ID = "m_gooby02",	lastLevel = 0 },
			{	ID = "m_gooby03",	lastLevel = 0 },
			{	ID = "m_gooby04",	lastLevel = 0 },
		]
	}
]
