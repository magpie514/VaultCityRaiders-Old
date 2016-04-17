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
}
var spots = null

onready var battleState = {
	actionStack = main.newArray(12),
	actionCurrent = 0,
	actions = 0
}

func connectUISignals():
	get_node("BattleUI/BattleChoice1").connect("_battlechoice1", self, "_receive_battlechoice1")
	get_node("BattleUI/BattleChoice2").connect("_battlechoice2", self, "_receive_battlechoice2")

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
	if not B: print("[!] No BGM specified for battle.")
	main.get_node("StreamPlayer").play()

func init(battleData):
	playerPartyInit(battleData.playerParty)
	enemyPartyInit(battleData.enemyParty)
	backgroundInit(battleData.background)
	bgmInit(battleData.bgm)
	for i in range(0, 6): charInit(true, party[i], i)
	for i in range(0, 3): charInit(false, enemyParty[i], i)

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

func collectActions():
	for i in range(0, 3): battleState.actionStack[i] = playerChoices[i]
	battleState.actions = 2

func actionInit(A):
	get_node("BattleView/Viewport").add_child(debugEffect.instance())
	get_node("BattleView/Viewport/BattleEffect").connect("actionNext", self, "_receive_actionNext")
	get_node("BattleView/Viewport/BattleEffect").set_pos(Vector2(400, 240))
#	get_node("BattleUI/ActionDisplay").init(party[A.char].skills[A.slot].name, A.power, false)

func set_phase(phase):
	#TODO:20 Define combat phases properly. @Combat +Brainstorm
	if phase == 0:
		phase = 0; print("Combat phase 0: Party action")
		get_node("BattleUI/BattleChoice1").start()
		nodes.mainCamera.make_current()
		nodes.mainCamera.zoom(1.5)
		cameraLook(Vector2(400,240))
	elif phase == 1:
		phase = 1; print("Combat phase 1: Character actions")
		currentChoice = 0
		get_node("BattleUI/BattleChoice2").show()
		beginCharChoice(0)
		nodes.mainCamera.zoomLinear(1.0, 20)
	elif phase == 2:
		phase = 2; print("Combat phase 2: Processing")
		#for i in range(0, 3): printAction(playerChoices[i])
		get_node("BattleUI/ActionDisplay").init("test", 500000, false)
		cameraLook(Vector2(400,240))
		battleState.actionCurrent = 0
		battleState.actions = 2
		collectActions()
		set_phase(0)
	elif phase == 3:
		phase = 3; print("Combat phase 3: Normal effects")
		actionInit(battleState.actionStack[0])
	elif phase == 4:
		phase = 4; print("Combat phase 4: End of turn effects")
		set_phase(5)
	elif phase == 5:
		phase = 5; print("Combat phase 5: Conclusion")
		if continueBattle(): set_phase(0)
		else: set_phase(6)
	elif phase == 6:
		phase = 6; print("Battle over")

func _receive_battlechoice1(choice):
	if choice == 1:		self.phase = 1
	elif choice == 2:	print("ruuun~")

func cameraLook(xy):
	var v = get_node("BattleView/Viewport").get_rect()
	nodes.mainCamera.set_pos(xy + Vector2(0, -80))

func getCharPos(side, slot):
	var spots = get_node("BattleView/Viewport/BG/BattleSpots")
	if side == 0:
		return spots.get_node(str("PlayerSide/P", slot, "/Char")).get_global_pos()
	else: return spots.get_node(str("EnemySide/P", slot)).get_pos()

func beginCharChoice(slot):
	if not party[slot].npc and charIsAble(party[slot]):
		get_node("BattleUI/BattleChoice2").init(party[slot])
		cameraLook(getCharPos(0, slot))	
	elif currentChoice < 5:
		currentChoice += 1
		beginCharChoice(currentChoice)
	else:
		get_node("BattleUI/BattleChoice2/Main").stop()
		self.phase = 2

func _receive_battlechoice2(action, slot, power, target):
	print(party[currentChoice].name, ":", action, ",", slot, ",", power, ",", target)
	main.sfxPlay("blip")
	playerChoices[currentChoice] = { char = currentChoice, action = action, slot = slot, power = power, target = target }
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
	else: set_phase(4)

func _on_Timer_timeout():
	actionInit(battleState.actionStack[battleState.actionCurrent])
	
func _receive_bgAnimDone():
	get_node("BattleUI").start()
	self.phase = 0
