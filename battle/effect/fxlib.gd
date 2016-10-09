extends Node2D
signal actionNext()

var battle = null
var caster = null
var defender = null
var casterSprite = null
var defenderSprite = null
onready var animPlayer = get_node("AnimationPlayer")

func init(B, C, D): #Battle node class pointer(!?), Caster, Defender
	battle = B; caster = C; defender = D
	casterSprite = battle.getCharSpriteNode(caster[0], caster[1])
	defenderSprite = battle.getCharSpriteNode(defender[0], defender[1])

func attachCaster(pos):
	if pos == 0:
		set_global_pos(casterSprite.get_global_pos())
	elif pos == 1:
		var finalPos = casterSprite.attackPos if casterSprite.attackPos != null else casterSprite.spritePos
		set_global_pos(finalPos.get_global_pos())
	elif pos == 2:
		var finalPos = casterSprite.centerPos if casterSprite.centerPos != null else casterSprite.centerPos
		set_global_pos(finalPos.get_global_pos())

func attachDefender(pos):
	if pos == 0:
		set_global_pos(defenderSprite.get_global_pos())
	elif pos == 1:
		var finalPos = defenderSprite.attackPos if defenderSprite.attackPos != null else defenderSprite.spritePos
		set_global_pos(finalPos.get_global_pos())
	elif pos == 2:
		var finalPos = defenderSprite.centerPos if defenderSprite.centerPos != null else defenderSprite.centerPos
		set_global_pos(finalPos.get_global_pos())


func attachFXDefender(node, pos):
	if pos == 0:
		node.set_global_pos(defenderSprite.get_global_pos())
	elif pos == 1:
		var finalPos = defenderSprite.attackPos if defenderSprite.attackPos != null else defenderSprite.spritePos
		node.set_global_pos(finalPos.get_global_pos())
	elif pos == 2:
		var finalPos = defenderSprite.centerPos if defenderSprite.centerPos != null else defenderSprite.centerPos
		node.set_global_pos(finalPos.get_global_pos())

func moveCasterStd(pos, time):
	print("moveCasterStd(", pos, ",", time, ")")
	var P = defenderSprite.get_global_pos()
	if pos == 0:
		casterSprite.moveTo(Vector2(P.x - 60, P.y), time)
	elif pos == 1:
		casterSprite.moveTo(Vector2(500, P.y), time)
	else:
		return

func resetCasterPos(time):
	casterSprite.moveTo(casterSprite.get_global_pos(), time)

func shakeDefender(time):
	defenderSprite.shake(time)

func changeAnim(anim):
	animPlayer.play(anim)

func cameraLookDefender():
	battle.cameraLookAt(defender[0], defender[1])

func _on_Timer_timeout(): finish()

func finish():
	emit_signal("actionNext")
	queue_free()
