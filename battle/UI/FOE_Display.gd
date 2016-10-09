extends Panel

onready var nodes = {
	bars = { vital = get_node("Display/Vital/Bar"), EP = get_node("Display/EP/Bar") },
	labels = { name = get_node("Display/Name"), vital = get_node("Display/Vital") },
	display = get_node("Display"),
	highlight = get_node("Highlight")
}

var character = {}
var active = false
var anim = { timer = 0, vital = 0, vital1 = 0, EP = 0, EP1 = 0, AD = 0, AD1 = 0 }
const ANIM_TIME = 60

func setVital(v, mv):
	nodes.bars.vital.set_value(float(v) / float(mv))

func setEP(ep, mep):
	nodes.bars.EP.set_value(float(ep) / float(mep))

func char_update(C):
	if (anim.vital != C.stats.V or anim.EP != C.stats.EP or anim.AD != C.stats.AD) and anim.timer == 0:
		anim.vital1 = C.stats.V; anim.EP1 = C.stats.EP
		anim.AD1 = C.stats.AD
		anim.timer = ANIM_TIME
	if anim.timer > 0:
		var x = float(anim.timer)/float(ANIM_TIME)
		setVital(int(lerp(anim.vital1, anim.vital, x)), C.baseStats.V)
		setEP(int(lerp(anim.EP1, anim.EP, x)), C.baseStats.EP)
		get_node("Display/ADIcon").set(int(lerp(anim.AD1, anim.AD, x)), true)
		anim.timer -= 1
		if anim.timer == 0:
			anim.vital = C.stats.V; anim.EP = C.stats.EP
			anim.over = C.stats.over; anim.AD = C.stats.AD
	else:
		setVital(C.stats.V, C.baseStats.V)
		setEP(C.stats.EP, C.baseStats.EP)
		get_node("Display/ADIcon").set(C.stats.AD, true)

func _process(delta):
	char_update(character)
	if active:			nodes.highlight.set_self_opacity(0.7 + (cos(OS.get_ticks_msec() * 0.007) * 0.3 ))
	else:				nodes.highlight.set_self_opacity(0.0)

func init(C):
	if C == null:
		nodes.display.hide()
		return
	else:
		character = C
		nodes.labels.name.set_text(character.name)
		char_update(character)
		set_process(true)
		show()
