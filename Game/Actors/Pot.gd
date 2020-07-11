extends KinematicBody2D

class_name Pot

var cover_off := false

func _on_TouchArea_pressed():
	if not $Cover/Anim.is_playing():
		cover_off = not cover_off
		
		if cover_off:
			$Cover/Anim.play("CoverOn")
			$Collision.disabled = true
			$CookingTime.start()
		else:
			$Cover/Anim.play_backwards("CoverOn")
			$Collision.disabled = false
			$CookingTime.stop()

func _on_CaptureArea_body_entered(body):
	if cover_off and body is GCrab:
		body = body as GCrab
		body.capture()
		Main.store_crab_cooking_amount += 1


func _on_CookingTime_timeout():
	Main.store_score += 1 * Main.store_crab_cooking_amount
	Main.store_time += 3 * Main.store_crab_cooking_amount
	Main.store_crab_cooking_amount = 0
	
	Events.emit_signal("update_score", Main.store_score)
	SoundManager.play_sound("ADD_SCORE")
