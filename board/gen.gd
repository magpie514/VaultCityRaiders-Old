extends Control

var tile = preload("res://board/pre.png")
var rect = tile.get_size()
const MAX_WIDTH = 115
const MAX_HEIGHT = 145
var width = 20
var height = 30
var branching = 10
var turning = 5
var block_redraw = true
var data = []
var dir_v = [Vector2(0,-1), Vector2(0,1), Vector2(-1,0), Vector2(1, 0)] #0 = Up, 1 = Down, 2 = Left, 3 = Right


func xy(x, y):
	return x + width * y

func interpolate(a, b, x):
	return (a * (1 - x) + b * x)
	
func inv_interpolate(mi, ma, x):
	return (x - mi) / (ma - mi)

func chance(i):
	return (randi() % 100 <= i)
	
func rand_odd(r):
	return (randi() % (r/2)) * 2
	

func _draw():
	if block_redraw:
		return
	draw_rect(Rect2(Vector2(0,0), get_size()), Color(0,0,0,1))
	for y in range(height):
		for x in range(width):
			if data[xy(x, y)] == 1:
				draw_texture_rect(tile, Rect2(Vector2(x,y) * rect, rect), false)
			elif data[xy(x,y)] == 2:
				draw_texture_rect(tile, Rect2(Vector2(x,y) * rect, rect), false, Color(0.5,0.5,0.5,1))
			elif data[xy(x,y)] == 3:
				draw_texture_rect(tile, Rect2(Vector2(x,y) * rect, rect), false, Color(0.5,0.5,1.0,1))
			elif data[xy(x,y)] == 4:
				draw_texture_rect(tile, Rect2(Vector2(x,y) * rect, rect), false, Color(1.0,0.0,0.0,1))
			elif data[xy(x,y)] == 5:
				draw_texture_rect(tile, Rect2(Vector2(x,y) * rect, rect), false, Color(0.0,1.0,0.0,1))
func _ready():
	get_node("/root/Node/Panel/SeedString").set_text(str(OS.get_unix_time()))
	print(Vector2(115, 145))


func cell_init(pos, life, dir, sub):
	var cell = {
		next = null,
		pos = pos,
		life = life,
		dir = dir,
		sub = sub,
		turn_lock = 0,
		branch_lock = 0
	}
	if not sub:
		cell.turn_lock = 2 + rand_odd(4)
		cell.branch_lock = cell.turn_lock
	return cell

func cell_add(s, cell):
	if s.size >= s.smax:
		return false
	else:
		s.size += 1
		if s.head == null:
			s.head = cell
		else:
			cell.next = s.head
			s.head = cell
		return true

func cell_die(s, cell):
	if s.head == null:
		return false
	else:
		if s.head == cell:
			if cell.next != null:
				s.head = cell.next
			else:
				s.head = null
		s.size -= 1
		if s.head == null:
			s.done = true
		return true
		

func cell_determine_heading(cell):
	var bias = 0
	var heading = 0
	bias = int(inv_interpolate(0, width, cell.pos.x) * 100)
	if cell.dir == 0:
		if chance(bias):
			heading = 2
		else:
			heading = 3
	else:
		heading = 0
	return heading
	
		
		
func cell_determine_master_heading(s, cell):
	if cell.turn_lock == 0:
		cell.turn_lock = 2 + rand_odd(4)
		if chance(turning):
			cell.dir = cell_determine_heading(cell)
	else:
		cell.turn_lock -= 1
		if cell.dir > 1 and (cell.pos.x < 2 or cell.pos.x > width - 2):
			cell.turn_lock = 2 + rand_odd(4)
			cell.branch_lock = 2
			cell.dir = 0
		elif cell.pos.y <= 3:
			cell.turn_count = 10
			cell.branch_lock = 10
			cell.dir = 0



func cell_determine_branch(s, cell):
	if cell.branch_lock <= 0 and cell.turn_lock >= 2 and (cell.pos.x > 2 and cell.pos.x < width - 2):
		cell.branch_lock = 2
		if chance(branching) and s.size < s.smax:
			cell_add(s, cell_init(cell.pos, 2 + rand_odd(6), cell_determine_heading(cell), true))
			cell.branch_lock += rand_odd(4)
	else:
		cell.branch_lock -= 1
						
func cell_check(s, cell):
	if cell.pos.x <= 0 or cell.pos.x >= width or cell.pos.y < 0 or cell.pos.y >= height:
		cell_die(s,cell)
		return true
	elif cell.sub and cell.life <= 0:
		cell_die(s,cell)
		return true
	else:
		return false


func cell_parse_master(s, cell):
	if cell_check(s, cell):
		return
	else:
		if cell.life == 0:
			data[xy(cell.pos.x, cell.pos.y)] = 3
		else:
			data[xy(cell.pos.x, cell.pos.y)] = 1
		cell.life += 1
		cell.pos += dir_v[cell.dir]
		cell_determine_master_heading(s, cell)
		cell_determine_branch(s, cell)
	
func cell_parse_sub(s, cell):
	cell.pos += dir_v[cell.dir]
	if cell_check(s, cell):
		return
	else:
		if data[xy(cell.pos.x, cell.pos.y)] == 1:
			cell_die(s, cell)
			return
		else:
			cell.life -= 1
			data[xy(cell.pos.x, cell.pos.y)] = 2
		
func cell_parse(s, cell):
	if not s.done:
		if cell.sub:
			cell_parse_sub(s, cell)
		else:
			cell_parse_master(s, cell)
	else:
		cell_die(s, cell)

		
func generate():
	var SEED = get_node("/root/Node/Panel/SeedString").get_text()
	print("Map seed:", SEED)
	#seed(int(SEED))
	var initial_x = width / 2
	var initial_y = height - 1
	var cell = null
	var cell_stack = {
		size = 0,
		smax = 32,
		head = null,
		done = false
	}
	
	cell_add(cell_stack, cell_init(Vector2(initial_x,initial_y), 1, 0, false))

	while not cell_stack.done:
		cell = cell_stack.head
		while cell != null:
			cell_parse(cell_stack, cell)
			cell = cell.next


func _on_ButtonOK_pressed():
	data.clear()
	self.set_size(Vector2(width, height) * rect)
	data.resize(width * height)
	generate()
	block_redraw = false
	update()

func _on_WidthSlider_value_changed(value):
	width = value
	get_node("/root/Node/Panel/WidthSlider/WidthLabel").set_text(str(width))

func _on_HeightSlider_value_changed(value):
	height = value
	get_node("/root/Node/Panel/HeightSlider/HeightLabel").set_text(str(height))


func _on_ButtonQuit_pressed():
	get_tree().quit()

func _on_BranchingSlider_value_changed(value):
	branching = value
	get_node("/root/Node/Panel/BranchingSlider/BranchingLabel").set_text(str(value, "%"))


func _on_SeedString_text_entered(text):
	print(text)


func _on_SeedButton_pressed():
	get_node("/root/Node/Panel/SeedString").set_text(str(randi()))


func _on_TurnSlider_value_changed(value):
	turning = value
	get_node("/root/Node/Panel/TurnSlider/TurnLabel").set_text(str(value, "%"))
