extends GCrab

class_name Crab

var direction = Vector2(1, 0).rotated(deg2rad(rand_range(0, 360))) * 100
var dest = Vector2.ZERO
var c_t = 0
var escape := false

func capture():
	.capture()
	$Anim.play("Captured")
	
func _process(delta):
	if c_t < 1 and escape:
		c_t += delta * 1.4
		global_position = Vector2(384/2, 208/2).linear_interpolate(dest, c_t)
	else:
		escape = false

func _on_ExitTime_timeout():
	if pot and pot.cover_off:
		is_capture = false
		$Collision.disabled = false
		clickeable = true
		escape = true
		
		dest = direction + Vector2(384/2, 208/2)
#		var tween = Tween.new()
#		tween.interpolate_property(
#			self,
#			"position",
#			Vector2(384/2, 208/2),
#			Vector2(384/2, 208/2) + direction,
#			0.5,
#			Tween.TRANS_LINEAR,
#			Tween.EASE_IN_OUT
#		)
#		tween.start()
		$Anim.play("Escape")
		Main.store_crab_cooking_amount -= 1
		
func _on_VisibilityNotifier2D_screen_exited():
	Events.emit_signal("out_screen_crab")
	queue_free()
