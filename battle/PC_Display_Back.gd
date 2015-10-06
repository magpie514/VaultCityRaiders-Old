extends Panel
#IDEA:10 Find instances where nodes are only called once, don't store those in variables. +Optimize
var nodes = {
	bars = { vital = "", EP = "" },
	labels = { name = "", vital = "", EP = ""	},
}

var character = {}

func setVital(v, mv):
	var val = float(v) / float(mv)
	if val >= 0.51:
			nodes.bars.vital.color = Color(0.0, 1.0, 0.0, 1.0)
	elif val >= 0.26:
			nodes.bars.vital.color = Color(1.0, 1.0, 0.0, 1.0)
	elif val >= 0.06:
			nodes.bars.vital.color = Color(1.0, 0.0, 0.0, 1.0)
	else:
			nodes.bars.vital.color = Color(0.5, 0.0, 0.0, 1.0)
	nodes.bars.vital.set_value(val)
	nodes.labels.vital.set_text(str(v, "/", mv))


func setEP(ep, mep):
	var val = float(ep) / float(mep)
	if val >= 0.51:
			nodes.bars.EP.color = Color(0.0, 1.0, 1.0, 1.0)
	elif val >= 0.26:
			nodes.bars.EP.color = Color(1.0, 1.0, 0.0, 1.0)
	elif val >= 0.06:
			nodes.bars.EP.color = Color(1.0, 0.0, 0.0, 1.0)
	else:
			nodes.bars.EP.color = Color(0.5, 0.0, 0.0, 1.0)
	nodes.bars.EP.set_value(val)
	nodes.labels.EP.set_text(str(ep))

func update(C):
	setVital(C.V, C.MV)
	setEP(C.EP, C.MEP)
	pass

func init(t):
	character = t
	nodes.labels.name.set_text(t.name)
	update(character)

func _ready():
	nodes.labels.name = get_node("NameLabel")
	nodes.labels.vital = get_node("VitalLabel")
	nodes.labels.EP = get_node("EPLabel")
	nodes.bars.vital = get_node("VitalBar")
	nodes.bars.EP = get_node("EPBar")
	pass
