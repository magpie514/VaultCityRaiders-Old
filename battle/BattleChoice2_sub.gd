extends Panel
#Slidey panel thingies! Because...well, it's convenient to have.

const ANIM_TIME = 0.15

export var direction = 0 #0 = up, 1 = down, 2 = left, 3 = right

var mainPos = Vector2(.0, .0)
var mainRect = Rect2(.0, .0, .0, .0)
var mainSlideTimer = .0
var mainFade = false

static func interpolate(a, b, x):
	return (a * (1 - x) + b * x)

func _ready():
	mainPos = get_pos()
	stop()

func _process(delta):
	if mainFade:
		if mainSlideTimer < ANIM_TIME:
			mainSlideTimer += delta
			if mainSlideTimer > ANIM_TIME:
				mainSlideTimer = ANIM_TIME
			self.set_opacity(1.0 - mainSlideTimer/ANIM_TIME)
			if direction == 0:
				set_pos(mainPos - Vector2(.0, interpolate(.0, mainRect.size.x, mainSlideTimer / ANIM_TIME)))
			elif direction == 1:
				set_pos(mainPos + Vector2(.0, interpolate(.0, mainRect.size.x, mainSlideTimer / ANIM_TIME)))
			elif direction == 2:
				set_pos(mainPos - Vector2(interpolate(.0, mainRect.size.x, mainSlideTimer / ANIM_TIME), .0))
			elif direction == 3:
				set_pos(mainPos + Vector2(interpolate(.0, mainRect.size.x, mainSlideTimer / ANIM_TIME), .0))
		else:
			self.hide()
			set_process(false)
	else:
		if mainSlideTimer < ANIM_TIME:
			mainSlideTimer += delta
			if mainSlideTimer > ANIM_TIME:
				mainSlideTimer = ANIM_TIME
			self.set_opacity(mainSlideTimer/ANIM_TIME * 0.9)
			if direction == 0:
				set_pos(mainPos - Vector2(.0, interpolate(mainRect.size.x, .0, mainSlideTimer / ANIM_TIME)))
			elif direction == 1:
				set_pos(mainPos + Vector2(.0, interpolate(mainRect.size.x, .0, mainSlideTimer / ANIM_TIME)))
			elif direction == 2:
				set_pos(mainPos - Vector2(interpolate(mainRect.size.x, .0, mainSlideTimer / ANIM_TIME), .0))
			elif direction == 3:
				set_pos(mainPos + Vector2(interpolate(mainRect.size.x, .0, mainSlideTimer / ANIM_TIME), .0))
		else:
			set_process(false)

func start():
	self.show()
	set_pos(mainPos - Vector2(mainRect.size.x, .0))
	mainRect = get_rect()
	mainSlideTimer = 0
	mainFade = false
	set_process(true)

func stop():
	mainSlideTimer = 0
	mainFade = true
	set_process(true)
