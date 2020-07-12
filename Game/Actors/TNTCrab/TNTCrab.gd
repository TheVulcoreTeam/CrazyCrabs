extends GCrab

class_name TNTCrab

func _on_VisibilityNotifier2D_screen_exited():
	Events.emit_signal("out_screen_crab")
	queue_free()
	
func _process(delta):
	if external_collision != null and external_collision.collider.name == 'Pot':
		#
		print('yahoo')
	
	if external_collision != null:
		print(external_collision.collider.name)

func capture():
	pass
