signal bgAnimDone

func _ready():
	get_node("AnimationPlayer").play("Intro")

func done():
	print("bg_done")
	emit_signal("bgAnimDone")