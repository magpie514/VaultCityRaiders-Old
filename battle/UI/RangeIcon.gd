#tool
extends Control

export(int, "Self", "Single", "V Line", "H Line", "Cone", "All") var form = 1 setget set_form
export(int, "Opposing", "Party", "Any") var side = 0 setget set_side
export(int, 0, 6, 1) var _range = 0 setget set_range
export(int, 0, 5, 1) var slot = 1 setget set_slot


func set_range(i):
	if i < 0: i = 0
	if i > 6: i = 6
	_range = i
	update()

func set_side(i):
	side = i
	update()

func set_slot(i):
	if i < 0: i = 0
	if i > 5: i = 5
	slot = i
	update()

func set_form(i):
	form = i
	update()



func _draw():
	var p = main.rangeResolve(side, form, _range, slot)
	var userslot = [[0,0,0], [0,0,0]]
	userslot[floor(slot / 3)][slot % 3] = 1
	for x in range(0, 2):
		for y in range(0, 3):
				if p[x][y]: draw_rect(Rect2(1 + (1-x) * 4, 4 + (y * 5), 3, 4), Color(1.0, 0.0, 0.0))
				else: draw_rect(Rect2(1 + (1-x) * 4, 4 + (y * 5), 3, 4), Color(0.3, 0.3, 0.3))
				if userslot[x][y]: draw_rect(Rect2(12 + x * 4, 4 + (y * 5), 3, 4), Color(0.0, 0.0, 1.0))
				else: draw_rect(Rect2(12 + x * 4, 4 + (y * 5), 3, 4), Color(0.3, 0.3, 0.3))


func init(T, S):
	slot = S
	form = T[0]
	side = T[1]
	_range = T[2]
	update()



func _ready():
	pass