extends GCrab

class_name TNTCrab

func _on_VisibilityNotifier2D_screen_exited():
	Events.emit_signal("out_screen_crab")
	queue_free()

func capture():
	pass
