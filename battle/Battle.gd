extends Node

var debugEffect = preload("res://battle/effect/debug02.tscn")
var choiceHighlighter = preload("res://battle/UI/BattleChoice_Highlighter.tscn")
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
	battleChoice2 = get_node("BattleUI/BattleChoice2"),
	battleUI = get_node("BattleUI"),
	spots = get_node("BattleView/Viewport/BG/BattleSpots"),
}

const BLANK_SPRITE = "res://data/char/blank/blank.tscn"


onready var battleState = {
	actionStack = main.newArray(12),
	actionCurrent = 0,
	actions = 0,
	turn = 1,
	fxNode = null,
}
#TODO: Needs a way to define party formation. Just a simple array will do?

#==== Battle phases ===================================================================================================

func battlePhase0():
	phase = 0; print("Combat phase 0: Party action")
	get_node("BattleView/Viewport/Highlighter").hide()
	nodes.mainCamera.make_current()
	nodes.mainCamera.zoom(1.5)
	nodes.battleChoice1.start()
	cameraCenter()
	nodes.battleUI.setTurn(battleState.turn)
	nodes.battleUI.clearHighlight()
	for i in range(0, 6):
		charUpdate(true, i); charUpdate(false, i)

func battlePhase1():
	phase = 1; print("Combat phase 1: Character actions")
	get_node("BattleView/Viewport/Highlighter").show()
	nodes.mainCamera.zoomLinear(1.0, 20)
	nodes.battleChoice2.show()
	currentChoice = 0
	beginCharChoice(0)

func battlePhase2():
	phase = 2; print("Combat phase 2: Processing")
	get_node("BattleView/Viewport/Highlighter").hide()
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
#NOTE ON PRIORITY: To save in battle phases I'll simply add 1000 to high-priority moves, and subtract 1000 for low-priority ones. That should work.


func battlePhase4():
	phase = 4; print("Combat phase 4: Actions")
	actionInit(battleState.actionStack[0])

func battlePhase5():
	phase = 5; print("Combat phase 5: End of turn effects")
	#Same as phase 3.
	set_phase(6)

func battlePhase6():
	phase = 6; print("Combat phase 6: End of turn")
	if continueBattle():
		battleState.turn += 1; set_phase(0)
	else: set_phase(7)

func battlePhase7():
	phase = 7; print("Combat phase 7: Battle over")
	return

func set_phase(p):
	#TODO:20 Define combat phases properly. Change to switch when they become available in gdscript, this is ugly.
	#As an alternative, check the phase is into boundaries and call str("battlePhase", p)
	p = int(clamp(p, 0, 7))
	if p == 0: battlePhase0()
	elif p == 1: battlePhase1()
	elif p == 2: battlePhase2()
	elif p == 3: battlePhase3()
	elif p == 4: battlePhase4()
	elif p == 5: battlePhase5()
	elif p == 6: battlePhase6()
	elif p == 7: battlePhase7()
#======================================================================================================================



#==== Camera functions ================================================================================================
func cameraLookAt(side, slot):
	cameraLook(getCharPos(side, slot))

func cameraLook(xy):
	var v = get_node("BattleView/Viewport").get_rect()
	nodes.mainCamera.set_pos(xy + Vector2(0, -80)) #TODO: Find a proper value to subtract

func cameraCenter():
	cameraLook(Vector2(400, 240))
#======================================================================================================================

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
		enemyParty = main.enemyp.party
	else: enemyParty = P

func backgroundInit(B):
	var bg = null
	if not B:
		print("[!] No background specified for battle.")
		bg = load("res://battle/background/RAYHAMMER01.tscn").instance()
	else: bg = load(B).instance()
	nodes.viewport.add_child(bg)
	bg.connect("bgAnimDone", self, "_receive_bgAnimDone")
	nodes.spots = get_node("BattleView/Viewport/BG/BattleSpots")

func init(battleData):
	playerPartyInit(battleData.playerParty);	enemyPartyInit(battleData.enemyParty)
	backgroundInit(battleData.background); 		main.bgmInit(battleData.bgm)
	get_node("BattleView/Viewport").add_child(choiceHighlighter.instance())

	for i in range(0, 6):
		charInit(true, i); charInit(false, i)
		playerChoices[i] = { active = false, side = false, char = null, charSlot = 0, action = [0, 0, 0], target = 0 }
	for i in range(0, 12):
		battleState.actionStack[i] = { active = false, side = false, char = null, charSlot = 0, action = [0,0,0], target = 0 }


func charInit(side, slot):
	var charscn = null;
	var char = null
	var P = getSidePointer(side)
	var displayRoot = ""
	var sideRoot = ""
	if side:
		displayRoot = "BattleUI/Display_Player/P"; 	sideRoot = "PlayerSide/P"
	else:
		displayRoot = "BattleUI/Display_Foe/P"; 	sideRoot = "EnemySide/P"

	if P.formation[slot] != null:
		char = P.character[P.formation[slot]]
		if char.charscn: charscn = load(char.charscn).instance()
		else: charscn = load(BLANK_SPRITE).instance()
		if char.equip.weapon[0] != null: char.equip.weapon[0].def = main.weaponDef[char.equip.weapon[0].tag]
			#print(char.equip.weapon[0].def)
		if char.equip.weapon[1] != null: char.equip.weapon[1].def = main.weaponDef[char.equip.weapon[1].tag]
			#print(char.equip.weapon[1].def)
		if charscn != null: nodes.spots.get_node(str(sideRoot, slot)).add_child(charscn)
		if side == false: charscn.set_scale(charscn.get_scale() * Vector2(-1, 1))
	get_node(str(displayRoot, slot)).init(char)


func charUpdate(side, slot):
	var partyPtr = getSidePointer(side)
	var charReal = partyPtr.formation[slot]
	if charReal != null:
		var char = partyPtr.character[charReal]
		char.stats.AD = char.baseStats.AD
	else: return

func continueBattle(): return true

func charCheckAction(char): return true

func charIsAble(char): return true

func sortByAGI(a, b):
	#TODO: Implement a function to favor collisions of identical/similar speeds based on difficulty mode.
	#On easy mode, collisions should always favor the player.
	if a.active == false: return false
	if a.AGI > b.AGI: return true
	else: return false

func getSidePointer(side):
	if side:	return party
	else:		return enemyParty

func printAction(A):
	var loc = getSidePointer(A.side)
	var tnam = enemyParty.character[1].name
	var nam = A.char.name
	if A.action[0] == main.BATTLE_ACTION_WEAPON:
		var wep = A.char.equip.weapon[A.action[1] / 2]  #either 0 or 1, for main or side arm.
		var wepnam = wep.def.name
		var skname = ""
		var lvStr = ""; if A.action[2] == 8: lvStr = "Over"
		else: lvStr = str(A.action[2] + 1)
		if A.action[1] % 2 == 0:	skname = wep.def.attack1.name
		else:						skname = wep.def.attack2.name
		return str(nam, " uses weapon ", wepnam, "'s skill ", skname, " (level ",  lvStr, ") on ",  tnam, ".")
	elif A.action[0] == main.BATTLE_ACTION_SKILL:
		return str(nam, " uses skill ", A.action[1], " lv.", A.action[2]," on ", tnam, ".")
	elif A.action[0] == main.BATTLE_ACTION_DEFEND: return str(nam, " defends.")
	else: return str(nam, " did something?")

func actionPrepare(side, charSlot, action, skillSlot, level, target):
	var partyPtr = getSidePointer(side)
	var char = partyPtr.character[partyPtr.formation[charSlot]]
	var AGI = char.stats.AGI
	if action == main.BATTLE_ACTION_DEFEND: AGI += main.BATTLE_DEFEND_AGI_BONUS
	return {
		active = true, side = side,
		char = char, charSlot = charSlot,
		action = [action, skillSlot, level], target = target,
		AGI = AGI #TODO: Add action bonus.
	}

func getCharSpriteNode(side, slot):
	if side == true:
		return nodes.spots.get_node(str("PlayerSide/P", slot, "/Char"))
	else: return nodes.spots.get_node(str("EnemySide/P", slot))

func getCharPos(side, slot):
	return getCharSpriteNode(side, slot).get_global_pos()

func collectActions():
	battleState.actions = 0
	for i in range(0, 12):
		battleState.actionStack[i] = {
			char = null, charSlot = 0, active = false, side = false,
			action = 0, slot = 0, power = 0, target = [0, 0]
		}
	for i in range(0, 6):
		if playerChoices[i].active == true:
			battleState.actionStack[battleState.actions] = playerChoices[i]
			battleState.actions += 1
		if charIsAble(enemyParty.formation[i]):
			battleState.actionStack[battleState.actions] = AIChoice(false, i)
			battleState.actions += 1
	battleState.actionStack.sort_custom(self, "sortByAGI")

func AIChoice(side, slot):
	return actionPrepare(side, slot, main.BATTLE_ACTION_DEFEND, 0, 0, [side, slot])

func beginCharChoice(slot):
	if slot <= 5:
		if party.formation[slot] != null:
			var n = party.formation[slot]
			get_node("BattleUI").setHighlight(true, slot)
			var char = party.character[n]
			if charIsAble(char):
				if not char.npc:
					nodes.battleChoice2.init(char)
					if slot > 1: nodes.battleChoice2.get_node("Main/B_Back").show()
					else: nodes.battleChoice2.get_node("Main/B_Back").hide()
					cameraLookAt(true, slot) #cameraLook(getCharPos(true, slot))
					get_node("BattleView/Viewport/Highlighter").set_pos(getCharPos(true, slot))
				else:
					playerChoices[slot] = AIChoice(true, slot)
					currentChoice = slot + 1; beginCharChoice(currentChoice)
			else: currentChoice = slot + 1; beginCharChoice(currentChoice)
		else:
			#TODO: add a "null" processing thing to the choice list to cover empty slots.
			currentChoice = slot + 1; beginCharChoice(currentChoice)
	else:
		get_node("BattleUI/BattleChoice2/Main").stop()
		get_node("BattleUI").clearHighlight()
		self.phase = 2


func _receive_battlechoice2(action, slot, power, target):
	playerChoices[currentChoice] = actionPrepare(true, currentChoice, action, slot, power, target)
	if currentChoice <= 5:
		currentChoice += 1; beginCharChoice(currentChoice)
	else:
		get_node("BattleUI/BattleChoice2/Main").stop()
		self.phase = 2

func processDamage(A, dmg, D): #Attacker, damage, defender
	#TODO: Apply elemental modifiers, status effects, active defense and buffs/debuffs here
	D.stats.V -= dmg[1]
	D.stats.V -= dmg[3]
	#TODO: Check for death and other states.

func actionProcessEffect(A):
	var loc = getSidePointer(A.side)
	var target = enemyParty.character[1]
	var nam = A.char.name
	if A.action[0] == main.BATTLE_ACTION_WEAPON:
		var wep = A.char.equip.weapon[A.action[1] / 2]  #either 0 or 1, for main or side arm.
		var WA = null
		if A.action[1] % 2 == 0:	WA = wep.def.attack1
		else:						WA = wep.def.attack2
		processDamage(A.char, WA.levelData[A.action[2]].damage, target)
	elif A.action[0] == main.BATTLE_ACTION_SKILL:
		print("skill pewpew")
		#return str(nam, " uses skill ", A.action[1], " lv.", A.action[2]," on ", tnam, ".")
	elif A.action[0] == main.BATTLE_ACTION_DEFEND:
		A.char.stats.AD = 300
	else:
		print("???")

func _receive_actionNext():
	#TODO: Process final damage and effects here.
	actionProcessEffect(battleState.actionStack[battleState.actionCurrent])
	if battleState.actionCurrent < battleState.actions:
		battleState.fxNode.disconnect("actionNext", self, "_receive_actionNext")
		battleState.actionCurrent += 1
		get_node("Timer").start()
	else: set_phase(5)

func getActionFX(A):
	var scene = null
	var loc = getSidePointer(A.side)
	if A.action[0] == main.BATTLE_ACTION_WEAPON:
		var wep = A.char.equip.weapon[A.action[1] / 2]  #either 0 or 1, for main or side arm.
		var WA = null
		if A.action[1] % 2 == 0:	WA = wep.def.attack1
		else:						WA = wep.def.attack2
		scene = load(wep.def.attack1.effect)
		return(scene.instance())
	elif A.action[0] == main.BATTLE_ACTION_SKILL:
		return(debugEffect.instance())
	elif A.action[0] == main.BATTLE_ACTION_DEFEND:
		return(debugEffect.instance())


func actionEffectInit(A):
	battleState.fxNode = getActionFX(A)
	getCharSpriteNode(A.side, A.charSlot).add_child(battleState.fxNode)
	battleState.fxNode.connect("actionNext", self, "_receive_actionNext")
	battleState.fxNode.init(self, [A.side, A.charSlot], [false, 1])

func actionInit(A):
	if A.active:
		print("[", battleState.actionCurrent, "/", battleState.actions - 1, "] ", printAction(A))
		cameraLookAt(A.side, A.charSlot)
		get_node("BattleUI").setHighlight(A.side, A.charSlot)
		actionEffectInit(A)
	else:
		battleState.actionCurrent += 1
		get_node("Timer").start()

func _receive_bgAnimDone():
	get_node("BattleUI").start()
	self.phase = 0

func _receive_battlechoice1(choice):
	if choice == 1:		self.phase = 1
	elif choice == 2:	print("ruuun~")

func _on_Timer_timeout(): #Crappy way to skip a frame.
	if battleState.actionCurrent < battleState.actions:
		actionInit(battleState.actionStack[battleState.actionCurrent])
	else: set_phase(5)
