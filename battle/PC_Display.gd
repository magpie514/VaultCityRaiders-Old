extends Control

var nodes = {
	bars = { vital = "", EP = "" },
	labels = { name = "", vital = "", EP = ""	},
}

var character = {}


var vital_colors = [Color(.9, .9, .9), Color(0, .9, 0), Color(.9, .9, 0), Color(.9, 0, 0), Color(0, 0, 0)]
var ep_colors = [Color(.9, .9, .9), Color(0, .9, .9), Color(0, .5, .9), Color(0, 0, .9), Color(.9, 0, 0)]
var blink = 1

#TODO:5 Display OVERDRIVE gauge
#TODO:4 Display status effects.

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
	if v > 0 and val < 0.0001:
		val = 0.0001
	nodes.bars.vital.set_value(val)
	nodes.labels.vital.set_text(str(v, "/", mv))


func setEP(ep, mep):
	var val = float(ep) / float(mep)
	nodes.bars.EP.color = ep_colors[bar_color(val)]
	if ep > 0 and val < 0.0001:
		val = 0.0001
	nodes.bars.EP.set_value(val)
	nodes.labels.EP.set_text(str(ep))

func char_update(C):
	setVital(C.V, C.MV)
	setEP(C.EP, C.MEP)
	if C.status == "ded":
		nodes.labels.name.add_color_override("font_color", Color(.9,0,0))
		get_node("Vital").add_color_override("font_color", Color(.9,0,0))
		get_node("EP").add_color_override("font_color", Color(.9,0,0))
		#FIXME:0 Only update on change
	
func _fixed_process(delta):
	char_update(character)

func init(C):
	character = C
	nodes.labels.name.set_text(character.name)
	char_update(character)
	self.set_fixed_process(true)
	
func _ready():
	nodes.labels.name = get_node("Name")
	nodes.labels.vital = get_node("Vital/Label")
	nodes.labels.EP = get_node("EP/Label")
	nodes.bars.vital = get_node("Vital/Bar")
	nodes.bars.EP = get_node("EP/Bar")

func _on_BlinkTimer_timeout():
	if blink == 0:
		blink = 1
	else:
		blink = 0
