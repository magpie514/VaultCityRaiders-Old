extends Node

func _receive_battlechoice1(choice):
	if choice == 1:
		self.phase = 1
	elif choice == 2:
		print("nigeru~")
	
var decision = false
var phase setget set_phase

func set_phase(phase):
	#TODO:20 Define combat phases properly. @Combat +Brainstorm
	print("Setting combat phase: ", phase)
	if phase == 0:
		phase = 0
		print("Combat phase 0: Party action")
		get_node("BattleUI/BattleChoice1").connect("_battlechoice1", self, "_receive_battlechoice1")
		get_node("BattleUI/BattleChoice1").start()
	elif phase == 1:
		phase = 1
		print("Combat phase 1: Character actions")
	elif phase == 2:
		phase = 2
		print("Combat phase 2: Resolution")


#FIXME:3 Add weapon attacks, skills, overdrives and a minimal inventory. @Character
var party = [
	{
		name = "Koishi",
		status = "OK",
		V = 5500,
		MV = 9999,
		EP = 1340500,
		MEP = 99999999,
		over = 99,
	},{
		name = "Magpie",
		status = "burn",
		V = 800,
		MV = 5400,
		EP = 22304,
		MEP = 999999,
		over = 50,
	},{
		name = "Kirarin",
		status = "OK",
		V = 9999,
		MV = 9999,
		EP = 5000,
		MEP = 10000,
		over = 99,
	},{
		name = "カメラあべ",
		status = "OK",
		V = 500,
		MV = 999,
		EP = 500,
		MEP = 500,
		over = 29,
	},{
		name = "Solid Snake",
		status = "ded",
		V = 0,
		MV = 999,
		EP = 45,
		MEP = 500,
		over = 1,
	},{
		name = "Angry Nerd",
		status = "OK",
		V = 1,
		MV = 99,
		EP = 99999,
		MEP = 99999,
		over = 100,
	},{
		name = "Gooby",
		status = "OK",
		V = 99999,
		MV = 99999,
		EP = 99999,
		MEP = 99999,
		over = 50,
	},{
		name = "Diancie",
		status = "OK",
		V = 90000,
		MV = 99999,
		EP = 19999,
		MEP = 99999,
		over = 50,
	}
]

var enemy_party = [
	{
		name = "Gun Enforcer",
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
		name = "Steel Slave",
		V = 100,
		MV = 50000,
		EP = 500,
		MEP = 2000
	}
]



func _fixed_process(delta):
	pass

func _ready():
	get_node("BattleUI/Display_Player/P0").init(party[0])
	get_node("BattleUI/Display_Player/P1").init(party[1])
	get_node("BattleUI/Display_Player/P2").init(party[2])
	get_node("BattleUI/Display_Player/P3").init(party[3])
	get_node("BattleUI/Display_Player/P4").init(party[4])
	get_node("BattleUI/Display_Player/P5").init(party[5])
	get_node("BattleUI/Display_Player/P6").init(party[6])
	get_node("BattleUI/Display_Player/P7").init(party[7])
	
	get_node("BattleUI/Display_Foe/P0").init(enemy_party[0])
	get_node("BattleUI/Display_Foe/P1").init(enemy_party[1])
	get_node("BattleUI/Display_Foe/P2").init(enemy_party[2])

	set_fixed_process(true)
	self.phase = 0
