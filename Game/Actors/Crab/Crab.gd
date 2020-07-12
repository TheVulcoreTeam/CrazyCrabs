extends GCrab

class_name Crab

func capture():
	.capture()
	$Anim.play("Captured")
	

func _on_ExitTime_timeout():
	if pot and pot.cover_off:
		is_capture = false
		$Collision.disabled = false
		clickeable = true
		
		var direction = Vector2(1, 0).rotated(deg2rad(rand_range(0, 360))) * 10
		var tween = Tween.new()
		tween.interpolate_property(
			self,
			"position",
			Vector2(384/2, 208/2),
			global_position + direction,
			4.5,
			Tween.TRANS_LINEAR,
			Tween.EASE_IN_OUT
		)
		tween.start()
		$Anim.play("Escape")
		Main.store_crab_cooking_amount -= 1
		
func _on_VisibilityNotifier2D_screen_exited():
	Events.emit_signal("out_screen_crab")
	queue_free()
