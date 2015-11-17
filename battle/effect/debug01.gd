extends Node2D
signal actionNext()

func _ready():
	get_node("Particles2D").set_emitting(true)
	get_node("Timer").start()


func _on_Timer_timeout():
		emit_signal("actionNext")
		queue_free()
