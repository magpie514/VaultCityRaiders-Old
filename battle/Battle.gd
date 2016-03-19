extends Node
	
	
var debugEffect = preload("res://battle/effect/debug01.xscn")

var decision = false
var phase setget set_phase
var currentChoice = 0
var playerChoices = []
var party = null

var battleState = {
	actionStack = [],
	actionCurrent = 0,
	actions = 0
}

#FIXME:3 Add weapon attacks, skills, overdrives and a minimal inventory. @Character

var enemyParty = [
	{
		name = "RAYHAMMER Pod",
		stats = {
			V = 14000,
			MV = 14000,
			EP = 9999,
			MEP = 9999,
			over = 0
		},
	},{
		name = "RAYHAMMER Pod",
		stats = {
			V = 14000,
			MV = 14000,
			EP = 9999,
			MEP = 9999,
			over = 0
		},
	},{
		name = "RAYHAMMER Pod",
		stats = {
			V = 14000,
			MV = 14000,
			EP = 9999,
			MEP = 9999,
			over = 0
		},
	}
]

func _process(delta):
	pass

func _ready():
	playerChoices.resize(5)
	battleState.actionStack.resize(10)
	var debugp = preload("res://battle/debug/debugparty.gd").new()
	get_node("BattleUI/BattleChoice1").connect("_battlechoice1", self, "_receive_battlechoice1")
	get_node("BattleUI/BattleChoice2").connect("_battlechoice2", self, "_receive_battlechoice2")
	init(debugp.party)

func init(P):
	party = P
	for i in [0, 1, 2, 6, 7]:
		get_node(str("BattleUI/Display_Player/P", i)).init(party[i])
	get_node("BattleUI/Display_Foe/P0").init(enemyParty[0])
	get_node("BattleUI/Display_Foe/P1").init(enemyParty[1])
	get_node("BattleUI/Display_Foe/P2").init(enemyParty[2])
	get_node("/root/main/StreamPlayer").play()
	set_process(false)
	self.phase = 0

func printAction(act):
	var typelabels = ["weapon", "skill", "overdrive", "defend"]
	if act.action in [0, 1, 2]:
		print(party[act.char].name, " used ", typelabels[act.action], " ", party[act.char].skills[act.slot].name, " with power ", act.power)
	else:
		print(party[act.char].name, " defended!")

func continueBattle():
	return true

func charIsAble(char):
	return true
	
func collectActions():
	battleState.actionStack[0] = playerChoices[0]
	battleState.actionStack[1] = playerChoices[1]
	battleState.actionStack[2] = playerChoices[2]
	battleState.actions = 2

func actionInit(A):
	get_node("BattleView/Viewport").add_child(debugEffect.instance())
	get_node("BattleView/Viewport/BattleEffect").connect("actionNext", self, "_receive_actionNext")
	get_node("BattleView/Viewport/BattleEffect").set_pos(Vector2(400, 200))
#	get_node("BattleUI/ActionDisplay").init(party[A.char].skills[A.slot].name, A.power, false)
	

func set_phase(phase):
	#TODO:20 Define combat phases properly. @Combat +Brainstorm
	if phase == 0:
		phase = 0
		print("Combat phase 0: Party action")
		get_node("BattleUI/BattleChoice1").start()
	elif phase == 1:
		phase = 1
		currentChoice = 0
		print("Combat phase 1: Character actions")
		get_node("BattleUI/BattleChoice2").show()
		get_node("BattleUI/BattleChoice2").init(party[0])
	elif phase == 2:
		phase = 2
		print("Combat phase 2: Processing")
		for i in range(0, 3):
			printAction(playerChoices[i])
		get_node("BattleUI/ActionDisplay").init("test", 500000, false)
		battleState.actionCurrent = 0
		battleState.actions = 2
		collectActions()
		set_phase(3)
	elif phase == 3:
		phase = 3
		print("Combat phase 3: Normal effects")
		actionInit(battleState.actionStack[0])
	elif phase == 4:
		phase = 4
		print("Combat phase 4: End of turn effects")
		set_phase(5)
	elif phase == 5:
		phase = 5
		print("Combat phase 5: Conclusion")
		if continueBattle():
			set_phase(0)
		else:
			set_phase(6)
	elif phase == 6:
		phase = 6
		print("Battle over")
		



func _receive_battlechoice1(choice):
	if choice == 1:
		self.phase = 1
	elif choice == 2:
		print("nigeru~")

func _receive_battlechoice2(action, slot, power, target):
	print(party[currentChoice].name, ":", action, ",", slot, ",", power, ",", target)
	get_node("/root/main/UI_SFX").play("blip")
	playerChoices[currentChoice] = {
		char = currentChoice,
		action = action,
		slot = slot,
		power = power,
		target = target
	}
	if currentChoice < 2:
		currentChoice += 1
		get_node("BattleUI/BattleChoice2").init(party[currentChoice])
	else:
		get_node("BattleUI/BattleChoice2/Main").stop()
		self.phase = 2
	
func _receive_actionNext():
	print("Next!", " curr:", battleState.actionCurrent, "/", battleState.actions)
	if battleState.actionCurrent < battleState.actions:
		get_node("BattleView/Viewport/BattleEffect").disconnect("actionNext", self, "_receive_actionNext")
		battleState.actionCurrent += 1
		get_node("Timer").start()
	else:
		set_phase(4)


func _on_Timer_timeout():
	actionInit(battleState.actionStack[battleState.actionCurrent])
