extends Control

var nodes = {
	bars = { vital = null, EP = null, over = null },
	labels = { name = null, vitalN = null, EPN = null, vital = null, EP = null, overN = null, over = null },
}

var character = null
var vital_colors = [Color(.75, .95, .75), Color(0, .9, 0), Color(.9, .9, 0), Color(.9, 0, 0), Color(0, 0, 0)]
var ep_colors = [Color(.75, .75, .95), Color(0, .9, .9), Color(0, .5, .9), Color(0, 0, .9), Color(.9, 0, 0)]
var status_colors = [Color(.9, .9, 0), Color(.9, 0, 0)] # 0 = Negative status, 1 = incapacitated.
var blink = 1

#NOTE:9 Remove node variables to nodes only called once. +Optimize
#TODO:0 Display OVERDRIVE gauge @GUI
#TODO:30 Display status effects. @GUI

func _ready():
	nodes.labels.name = get_node("Display/Name")

	nodes.labels.vitalN = get_node("Display/Vital/Label")
	nodes.labels.vital = get_node("Display/Vital")
	nodes.bars.vital = get_node("Display/Vital/Bar")
	
	nodes.labels.EPN = get_node("Display/EP/Label")
	nodes.labels.EP = get_node("Display/EP")
	nodes.bars.EP = get_node("Display/EP/Bar")
	
	nodes.labels.overN = get_node("Display/Over/Label")
	nodes.labels.over = get_node("Display/Over/Label")
	nodes.bars.over = get_node("Display/Over/Bar")

func _process(delta):
	char_update(character)

func init(C):
	if C == null:
		get_node("Display").hide() #NOTE:0 Failsafe. If that party slot is empty, bail out immediately.
		return
	else:
		get_node("Display").show() #Just in case...
	character = C
	nodes.labels.name.set_text(character.name)
	if C.stats.awakening == false:
		get_node("Display/Over").set_text("???")
	char_update(character)
	self.set_process(true)

func bar_color(val):
	if val >= 0.999999:
		return 0
	elif val >= 0.51:
		return 1
	elif val >= 0.26:
		return 2
	elif val >= 0.06:
		return 3
	else:
		return 3 + blink

func setVital(v, mv):
	var val = float(v) / float(mv)
	nodes.bars.vital.color = vital_colors[bar_color(val)]
	if v > 0 and val < 0.0001: 	#NOTE:0 A safeguard in case it's a very low percentage, but still over 1, so it still shows a bit of bar.
		val = 0.0001
	nodes.bars.vital.set_value(val)
	nodes.labels.vitalN.set_text(str(v, "/", mv))

func setEP(ep, mep):
	var val = float(ep) / float(mep)
	nodes.bars.EP.color = ep_colors[bar_color(val)]
	if ep > 0 and val < 0.0001:
		val = 0.0001
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
	if C.status == "ded":
		text_color_overrides(status_colors[1])
		#FIXME:0 Only update on change

func _on_BlinkTimer_timeout():
	if blink == 0:
		blink = 1
	else:
		blink = 0
