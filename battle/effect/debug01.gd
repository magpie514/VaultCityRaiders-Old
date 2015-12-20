extends Node2D
signal actionNext()

func _ready():
	get_node("Particles2D").set_emitting(true)
	get_node("Timer").start()
	var aaa = RawArray()
	aaa.resize(32)
	for i in range(0, 32):
		aaa[i] = 0x00
	aaa[0] = 0x10
	var a = Marshalls.raw_to_base64(aaa)
	print(a)
	print(aaa)
	print(Marshalls.base64_to_raw(a))


func _on_Timer_timeout():
		emit_signal("actionNext")
		queue_free()

