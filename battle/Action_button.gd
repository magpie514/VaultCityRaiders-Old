extends Button

export var result = 0

var testaction = {
	name = "Megaton Impact",
	energy = false,
	melee = false,
	element = 0,
	element_secondary = false,
	element2 = 0,
	power_source = 0,
	levels_max = 4,
	levels = [500, 2000, 10000, 50000, 200000, 0, 0, 0, 0, 0, 0],
	
	
	
}

#TODO: Find a way to make the last power level be remembered.
func init(act):
	get_node("NameLabel").set_text(act.name)

func _ready():
	init(testaction)
	pass
