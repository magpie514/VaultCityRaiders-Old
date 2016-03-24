extends Control

onready var nodes = {
	bars = {
		vital = get_node("Vital/Bar"),
		EP = get_node("EP/Bar"),
		over = get_node("Over/Bar")
	},
	labels = {
		name = get_node("Name"),
		vitalN = get_node("Vital/Label"),
		vital = get_node("Vital"),
		EPN = get_node("EP/Label"),
		EP = get_node("EP"),
		overN = get_node("Over/Label"),
		over = get_node("Over")
	},
}

var character = null
var vital_colors = [Color(.75, .95, .75), Color(0, .9, 0), Color(.9, .9, 0), Color(.9, 0, 0), Color(0, 0, 0)]
var ep_colors = [Color(.75, .75, .95), Color(0, .9, .9), Color(0, .5, .9), Color(0, 0, .9), Color(.9, 0, 0)]
var status_colors = [Color(.9, .9, 0), Color(.9, 0, 0)] # 0 = Negative status, 1 = incapacitated.
var blink = 1
#TODO:30 Display status effects. @GUI

func _process(delta):
	char_update(character)

func init(C):
	if C == null:
		hide()
		return
	else: show()

	character = C
	nodes.labels.name.set_text(character.name)
	if C.stats.awakening == false: nodes.labels.over.set_text("???")
	char_update(character)
	self.set_process(true)

func bar_color(val):
	if val >= 0.999999: return 0
	elif val >= 0.51:	return 1
	elif val >= 0.26:	return 2
	elif val >= 0.06:	return 3
	else:				return 3 + blink

func setVital(v, mv):
	var val = float(v) / float(mv)
	nodes.bars.vital.color = vital_colors[bar_color(val)]
	if v > 0 and val < 0.0001:	val = 0.0001
	nodes.bars.vital.set_value(val)
	nodes.labels.vitalN.set_text(str(v))

func setEP(ep, mep):
	var val = float(ep) / float(mep)
	nodes.bars.EP.color = ep_colors[bar_color(val)]
	if ep > 0 and val < 0.0001:	val = 0.0001
	nodes.bars.EP.set_value(val)
	nodes.labels.EPN.set_text(str(ep))

func setOver(o):
	var val = float(o) / 100.0
	nodes.bars.over.color = Color(1,.6,0)
	nodes.bars.over.set_value(val)
	nodes.labels.overN.set_text(str(o, "%"))

func text_color_overrides(color):
	nodes.labels.name.add_color_override("font_color", color)
	nodes.labels.vital.add_color_override("font_color", color)
	nodes.labels.vitalN.add_color_override("font_color", color)
	nodes.labels.EP.add_color_override("font_color", color)
	nodes.labels.EPN.add_color_override("font_color", color)

func char_update(C):
	setVital(C.stats.V, C.stats.MV)
	setEP(C.stats.EP, C.stats.MEP)
	setOver(C.stats.over)
	get_node("ADIcon").set(C.stats.AD, true)
	if C.status == "ded":	text_color_overrides(status_colors[1]) #FIXME:0 Only update on change

func _on_BlinkTimer_timeout():
	if blink == 0:	blink = 1
	else:			blink = 0
