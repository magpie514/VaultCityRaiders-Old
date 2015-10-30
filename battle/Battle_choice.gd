extends Panel

signal _battlechoice1(choice)

const TIMER_INIT = 10
const TIMER_LOW = 5
const TIMER_VLOW = 2
const TIMER_COLORS = [Color(1,1,1), Color(1,.5,0), Color(1,0,0)]
const ANIM_TIME = 0.15

var timer = TIMER_INIT
var color = TIMER_COLORS[0]
var nodes = { timer = null, countdown = null }
var active = false
var choice = false
var t_pos = Vector2(0, 0)
var t_rect = Rect2(0, 0, 0, 0)
var anim_timer = 0.0
var fade = false

static func interpolate(a, b, x):
	return (a * (1 - x) + b * x)

func _ready():
	nodes.timer = get_node("TimerLabel")
	nodes.countdown = get_node("Countdown")
	t_pos = self.get_pos()
	self.stop()

func _process(delta):
	if fade:
		if anim_timer < ANIM_TIME:
			anim_timer += delta
			if anim_timer > ANIM_TIME:
				anim_timer = ANIM_TIME
			self.set_opacity(1.0 - anim_timer/ANIM_TIME)
			set_pos(t_pos - Vector2(0, interpolate(0, t_rect.size.y, anim_timer / ANIM_TIME)))
		else:
			self.hide()
			set_process(false)
	else:
		if anim_timer < ANIM_TIME:
			anim_timer += delta
			if anim_timer > ANIM_TIME:
				anim_timer = ANIM_TIME
			self.set_opacity(anim_timer/ANIM_TIME * 0.75)
			set_pos(t_pos - Vector2(0, interpolate(t_rect.size.y, 0, anim_timer / ANIM_TIME)))
		else:
			set_process(false)

func start():
	active = true
	timer = TIMER_INIT
	nodes.timer.set_text(str(timer))
	nodes.timer.add_color_override("font_color", color)
	nodes.countdown.start()
	self.show()
	t_rect = get_rect()
	set_pos(t_pos - Vector2(0, t_rect.size.y))
	anim_timer = 0
	fade = false
	set_process(true)

func stop():
	active = false
	timer = 0
	nodes.countdown.stop()
	anim_timer = 0
	fade = true
	set_process(true)

func _on_Countdown_timeout():
	if active == false:
		return
	timer -= 1
	if timer <= 0:
		_on_B_Fight_pressed()
	else:
		nodes.timer.set_text(str(timer))
		if timer > TIMER_LOW:
			color = TIMER_COLORS[0]
		elif timer > TIMER_VLOW:
			color = TIMER_COLORS[1]
		else:
			color = TIMER_COLORS[2]
		nodes.timer.add_color_override("font_color", color)

func _on_B_Fight_pressed():
	self.emit_signal("_battlechoice1", 1)
	self.stop()

func _on_B_Run_pressed():
	get_tree().quit()

func _on_B_Talk_pressed():
	self.emit_signal("_battlechoice1", 3)
	self.stop()

func _on_B_Skill_pressed():
	self.emit_signal("_battlechoice1", 1)
	self.stop()

func _on_B_Item_pressed():
	self.emit_signal("_battlechoice1", 5)
	self.stop()
