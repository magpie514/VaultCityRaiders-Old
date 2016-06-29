extends Node
	
var debugEffect = preload("res://battle/effect/debug01.xscn")
var decision = false
var phase setget set_phase
var currentChoice = 0
onready var playerChoices = main.newArray(6)
var bgAnimDone = false
var party = null
var enemyParty = null
onready var nodes = {
	mainCamera = get_node("BattleView/Viewport/Camera2D"),
	viewport = get_node("BattleView/Viewport"),
	battleChoice1 = get_node("BattleUI/BattleChoice1"),
	battleChoice2 = get_node("BattleUI/BattleChoice2")
}
var spots = null

onready var battleState = {
	actionStack = main.newArray(12),
	actionCurrent = 0,
	actions = 0
}

func connectUISignals():
	nodes.battleChoice1.connect("_battlechoice1", self, "_receive_battlechoice1")
	nodes.battleChoice2.connect("_battlechoice2", self, "_receive_battlechoice2")

func _ready():
	connectUISignals()
	init(main.battleData)

func playerPartyInit(P):
	if P == null:
		print("[!] No player party specified for battle.")
		party = main.debugp.party
	else: party = P
	
func enemyPartyInit(P):
	if P == null:
		print("[!] No enemy party specified for battle.")
		enemyParty = main.enemyp.enemyParty
	else: enemyParty = P

func backgroundInit(B):
	var bg = null
	if not B:
		print("[!] No background specified for battle.")
		bg = load("res://battle/background/RAYHAMMER01.tscn").instance()
	else: bg = load(B).instance()
	nodes.viewport.add_child(bg)
	bg.connect("bgAnimDone", self, "_receive_bgAnimDone")
	spots = get_node("BattleView/Viewport/BG/BattleSpots")

func bgmInit(B):
	if not B: 
		print("[!] No BGM specified for battle.")
		var bgm = load("res://music/EOIV_Storm.ogg")
		main.get_node("StreamPlayer").set_stream(bgm)
		main.get_node("StreamPlayer").set_loop(true)
	main.get_node("StreamPlayer").play()

func init(battleData):
	playerPartyInit(battleData.playerParty)
	enemyPartyInit(battleData.enemyParty)
	backgroundInit(battleData.background)
	bgmInit(battleData.bgm)
	for i in range(0, 6): charInit(true, party[i], i)
	for i in range(0, 6): charInit(false, enemyParty[i], i)
	for i in range(0, 12): battleState.actionStack[i] = { side = false, char = 0, action = 0, slot = 0, power = 0, target = 0 }

func charInit(side, char, slot):
	var charscn = null
	if char.charscn: charscn = load(char.charscn).instance()
	else: charscn = load("res://data/char/blank/blank.tscn").instance()
	if side:
		spots.get_node(str("PlayerSide/P", slot)).add_child(charscn)
		get_node(str("BattleUI/Display_Player/P", slot)).init(char)
	else:
		charscn.set_scale(charscn.get_scale() * Vector2(-1, 1))
		spots.get_node(str("EnemySide/P", slot)).add_child(charscn)
		get_node(str("BattleUI/Display_Foe/P", slot)).init(char)

func continueBattle():
	return true

func charCheckAction(char):
	return true

func charIsAble(char):
	return true

func sortByAGI(a, b):
	#Implement a function to favor collisions of identical/similar speeds based on difficulty mode.
	#On easy mode, collisions should always favor the player.
	var agi1 = 0
	var agi2 = 0
	if a.side: agi1 = party[a.char].stats.AGI
	else: agi1 = enemyParty[a.char].stats.AGI
	if b.side: agi2 = party[b.char].stats.AGI
	else: agi2 = enemyParty[b.char].stats.AGI
	if agi1 > agi2: return true
	else: return false

func collectActions():
	for i in range(0, 5): battleState.actionStack[i] = playerChoices[i]
	battleState.actionStack[5] = { side = true, char = 5, action = 3, slot = 0, power = 0, target = 0 }
	for i in range(0, 6): battleState.actionStack[6+i] = { side = false, char = i, action = 3, slot = 0, power = 0, target = 0 }
	print(battleState.actionStack)
	battleState.actionStack.sort_custom(self, "sortByAGI")
	print(battleState.actionStack)
	battleState.actions = 11

func actionInit(A):
	cameraLook(getCharPos(A.side, A.char))
	get_node("BattleView/Viewport").add_child(debugEffect.instance())
	get_node("BattleView/Viewport/BattleEffect").connect("actionNext", self, "_receive_actionNext")
	get_node("BattleView/Viewport/BattleEffect").set_pos(Vector2(400, 240))
#	get_node("BattleUI/ActionDisplay").init(party[A.char].skills[A.slot].name, A.power, false)

#==== Battle phases ===================================================================================================

func battlePhase0():
	phase = 0; print("Combat phase 0: Party action")
	nodes.mainCamera.make_current()
	nodes.mainCamera.zoom(1.5)
	nodes.battleChoice1.start()
	cameraCenter()
	clearDebugAction()

func battlePhase1():
	phase = 1; print("Combat phase 1: Character actions")
	nodes.mainCamera.zoomLinear(1.0, 20)
	nodes.battleChoice2.show()
	currentChoice = 0
	beginCharChoice(0)

func battlePhase2():
	phase = 2; print("Combat phase 2: Processing")
	#get_node("BattleUI/ActionDisplay").init("test", 500000, false) #Assign a reference to this node.
	cameraCenter()
	battleState.actionCurrent = 0
	battleState.actions = 4
	collectActions()
	set_phase(3)
	
func battlePhase3():
	phase = 3; print("Combat phase 3: Start of turn actions")
	#Set special actions here, usually stuff that belongs to plot, scripted events, whatever.
	set_phase(4)
#NOTES ON PRIORITY: To save in battle phases I'll simply add 1000 to high-priority moves, and subtract 1000 for low-priority ones. That should work.


func battlePhase4():
	phase = 4; print("Combat phase 5: Actions")
	actionInit(battleState.actionStack[0])

func battlePhase5():
	phase = 5; print("Combat phase 6: End of turn effects")
	#Same as phase 3.
	set_phase(6)

func set_phase(p):
	#TODO:20 Define combat phases properly. Change to switch when they become available in gdscript, this is ugly.
	if p == 0: battlePhase0()
	elif p == 1: battlePhase1()
	elif p == 2: battlePhase2()
	elif p == 3: battlePhase3()
	elif p == 4: battlePhase4()
	elif p == 5: battlePhase5()
	elif p == 6:
		phase = 6; print("Combat phase 6: End of turn")
		if continueBattle(): set_phase(0)
		else: set_phase(7)
	elif p == 7:
		phase = 7; print("Combat phase 7: Battle over")
		return


func cameraLook(xy):
	var v = get_node("BattleView/Viewport").get_rect()
	nodes.mainCamera.set_pos(xy + Vector2(0, -80)) #TODO: Find a proper value to subtract
	
func cameraCenter():
	cameraLook(Vector2(400, 240))

func getCharPos(side, slot):
	var spots = get_node("BattleView/Viewport/BG/BattleSpots")
	if side == true:
		return spots.get_node(str("PlayerSide/P", slot, "/Char")).get_global_pos()
	else: return spots.get_node(str("EnemySide/P", slot)).get_global_pos()
	
func printDebugAction(choice, action, slot, power, target):
	var act = ""
	var nam = party[choice].name
	if action == 0: return str(nam, " attacks ", target, ".")
	elif action == 1: return str(nam, " uses skill ", slot, " lv.", power," on ", target, ".")
	elif action == 3: return str(nam, " defends.")
	else: return str(nam, " did something?")

func clearDebugAction():
	for i in range(0, 6):
		print(i)
		get_node(str("BattleUI/Debug/Choice", i)).set_text("")

func beginCharChoice(slot):
	if not party[slot].npc and charIsAble(party[slot]):
		get_node("BattleUI/BattleChoice2").init(party[slot])
		cameraLook(getCharPos(true, slot))	
	elif currentChoice < 5:
		currentChoice += 1
		beginCharChoice(currentChoice)
	else:
		get_node("BattleUI/BattleChoice2/Main").stop()
		self.phase = 2

func _receive_battlechoice2(action, slot, power, target):
	playerChoices[currentChoice] = { side = true, char = currentChoice, action = action, slot = slot, power = power, target = target }
	get_node(str("BattleUI/Debug/Choice", currentChoice)).set_text(printDebugAction(currentChoice, action, slot, power, target))
	if currentChoice < 5:
		currentChoice += 1
		beginCharChoice(currentChoice)
	else:
		get_node("BattleUI/BattleChoice2/Main").stop()
		self.phase = 2
	
func _receive_actionNext():
	print("Next!", " curr:", battleState.actionCurrent, "/", battleState.actions)
	if battleState.actionCurrent < battleState.actions:
		get_node("BattleView/Viewport/BattleEffect").disconnect("actionNext", self, "_receive_actionNext")
		battleState.actionCurrent += 1
		get_node("Timer").start()
	else: set_phase(5)

func _on_Timer_timeout(): #Crappy way to skip a frame.
	actionInit(battleState.actionStack[battleState.actionCurrent])
	
func _receive_bgAnimDone():
	get_node("BattleUI").start()
	self.phase = 0

func _receive_battlechoice1(choice):
	if choice == 1:		self.phase = 1
	elif choice == 2:	print("ruuun~")