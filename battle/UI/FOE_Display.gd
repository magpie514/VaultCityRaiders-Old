extends Panel

onready var nodes = {
	bars = { vital = get_node("Display/Vital/Bar") },
	labels = { name = get_node("Display/Name"), vital = get_node("Display/Vital") },
	display = get_node("Display"),
}

var character = {}
var vital_colors = [Color(.8, .9, .8), Color(0, .9, 0), Color(.9, .9, 0), Color(.9, 0, 0), Color(0, 0, 0)]
var blink = 1

func bar_color(val):
	if val >= 0.999999:	return 0
	elif val >= 0.51:	return 1
	elif val >= 0.26:	return 2
	elif val >= 0.06:	return 3
	else:				return 3 + blink

func setVital(v, mv):
	var val = float(v) / float(mv)
	nodes.bars.vital.color = vital_colors[bar_color(val)]
	if v > 0 and val < 0.0001:	val = 0.0001
	nodes.bars.vital.set_value(val)

func char_update(C):
	setVital(C.stats.V, C.stats.MV)
	
func _process(delta):
	char_update(character)

func init(C):
	character = C
	nodes.labels.name.set_text(character.name)
	char_update(character)
	self.set_process(true)
	show()
	
func _ready():
	hide()

func _on_BlinkTimer_timeout():
	if blink == 0:	blink = 1
	else:			blink = 0
