extends Node

var party = [
	{
		name = "Koishi",
		status = "OK",
		V = 5500,
		MV = 9999,
		EP = 1340500,
		MEP = 99999999
	},{
		name = "Magpie",
		status = "burn",
		V = 800,
		MV = 5400,
		EP = 22304,
		MEP = 999999
	},{
		name = "Kirarin",
		status = "OK",
		V = 9999,
		MV = 9999,
		EP = 5000,
		MEP = 10000
	},{
		name = "Cameraman Abe",
		status = "OK",
		V = 500,
		MV = 999,
		EP = 500,
		MEP = 500
	},{
		name = "Solid Snake",
		status = "ded",
		V = 0,
		MV = 999,
		EP = 45,
		MEP = 500
	},{
		name = "Angry Nerd",
		status = "OK",
		V = 1,
		MV = 99, 
		EP = 99999,
		MEP = 99999
	},{
		name = "Gooby",
		status = "OK",
		V = 99999,
		MV = 99999,
		EP = 99999,
		MEP = 99999
	},{
		name = "Jay",
		status = "OK",
		V = 90000,
		MV = 99999,
		EP = 9999999,
		MEP = 9999999
	}
]

var enemy_party = [
	{
		name = "Evil Wizard",
		V = 2900,
		MV = 14000,
		EP = 1,
		MEP = 5400
	},{
		name = "Satellite Pod",
		V = 5000,
		MV = 14000,
		EP = 9999,
		MEP = 9999
	},{
		name = "Corrupt Politician",
		V = 1,
		MV = 5,
		EP = 5,
		MEP = 20
	}
]

func _ready():
	get_node("Display_Player/P0").init(party[0])
	get_node("Display_Player/P1").init(party[1])
	get_node("Display_Player/P2").init(party[2])
	get_node("Display_Player/P3").init(party[3])
	get_node("Display_Player/P4").init(party[4])
	get_node("Display_Player/P5").init(party[5])
	get_node("Display_Player/P6").init(party[6])
	get_node("Display_Player/P7").init(party[7])
	pass


