extends Control

onready var nodes = {
	icons = {
		contact = get_node("ContactIcon"),
		element1 = get_node("ElementIcon"),
		element2 = get_node("ElementIcon2"),
		AD = get_node("ADIcon"),
		ACC = get_node("ACCIcon"),
		AGI = get_node("AGIIcon"),
		rng = get_node("RangeIcon"),
	},
	labels = {
		element1 = get_node("ElementIcon/Label"),
		element2 = get_node("ElementIcon2/Label"),
		AGI = get_node("AGIIcon/Label"),
		ACC = get_node("ACCIcon/Label"),
	},
}

var testskl = {
	contact = true,
	damage = [1, 2500, 2, 2500],
	AD = 50,
	absoluteAD = false,
	ACC = 31,
	AGI = 0,
	target = [main.TARGET_SINGLE, main.TARGET_SIDE_ENEMY, 2],
}

func init(data):
	if data.contact:
		nodes.icons.contact.set_modulate(Color(.6,.2,.2))
		nodes.icons.contact.set_region_rect(Rect2(80, 0, 20, 20))
	else:
		nodes.icons.contact.set_modulate(Color(.2,.6,.8))
		nodes.icons.contact.set_region_rect(Rect2(100, 0, 20, 20))

	if data.damage[0] > 0:
		nodes.icons.element1.show()
		nodes.icons.element1.set_modulate(main.elementColor(data.damage[0]))
		nodes.labels.element1.set_text(str(data.damage[1]))
		if data.damage[2] > 0:
			nodes.icons.element2.show(); nodes.labels.element2.show()
			nodes.icons.element2.set_modulate(main.elementColor(data.damage[2]))
			nodes.labels.element2.set_text(str(data.damage[3]))
		else:
			nodes.icons.element2.show(); nodes.labels.element2.hide()
			nodes.icons.element2.set_modulate(main.elementColor(data.damage[0]))
	else:
		nodes.icons.element1.hide(); nodes.icons.element2.hide()

	#Set accuracy value and icon.
	if data.ACC > 89:
		nodes.icons.ACC.set_modulate(Color(0.8, 0.8, 0.8))
		nodes.labels.ACC.add_color_override("font_color", Color(1.0, 1.0, 1.0))
	elif data.ACC > 59:
		nodes.icons.ACC.set_modulate(Color(0.8, 0.8, 0.8))
		nodes.labels.ACC.add_color_override("font_color", Color(1.0, 1.0, 0.8))
	elif data.ACC > 29:
		nodes.icons.ACC.set_modulate(Color(0.6, 0.6, 0.6))
		nodes.labels.ACC.add_color_override("font_color", Color(1.0, 0.8, 0.5))
	else:
		nodes.icons.ACC.set_modulate(Color(0.4, 0.4, 0.4))
		nodes.labels.ACC.add_color_override("font_color", Color(1.0, 0.2, 0.2))
	nodes.labels.ACC.set_text(str(data.ACC, "%"))

	if data.AGI > 0:
		nodes.icons.AGI.set_modulate(Color(0.4, 0.4, 0.4))
		nodes.labels.AGI.add_color_override("font_color", Color(0.6, 0.8, 1.0))
		nodes.labels.AGI.set_text(str("+",data.AGI))
	elif data.AGI < 0:
		nodes.icons.AGI.set_modulate(Color(0.4, 0.4, 0.4))
		nodes.labels.AGI.add_color_override("font_color", Color(1.0, 0.2, 0.2))
		nodes.labels.AGI.set_text(str("-",data.AGI))
	else:
		nodes.icons.AGI.set_modulate(Color(0.8, 0.8, 0.8))
		nodes.labels.AGI.add_color_override("font_color", Color(1.0, 1.0, 1.0))
		nodes.labels.AGI.set_text("0")

	nodes.icons.AD.set(data.AD, data.absoluteAD)
	nodes.icons.rng.init(data.target, 1)

func _ready():
	#init(testskl)
	pass
