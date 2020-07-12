extends KinematicBody2D

class_name Pot

var cover_off := false

func _on_TouchArea_pressed():
	if not $Cover/Anim.is_playing():
		cover_off = not cover_off
		
		if cover_off:
			$Cover/Anim.play("CoverOn")
			$Collision.disabled = true
			$CookingTime.stop()
			SoundManager.play_sound("POT_OFF")
		else:
			$Cover/Anim.play_backwards("CoverOn")
			$Collision.disabled = false
			$CookingTime.start()
			SoundManager.play_sound("POT_ON")

func _on_CaptureArea_body_entered(body):
	if cover_off and body is GCrab:
		body = body as GCrab
		body.capture()
		Main.store_crab_cooking_amount += 1


func _on_CookingTime_timeout():
	var score_made = 1 * Main.store_crab_cooking_amount
	Main.store_score += score_made
	Main.store_time += 3 * Main.store_crab_cooking_amount
	Main.store_crab_cooking_amount = 0

	
	Events.emit_signal("update_score", Main.store_score)
	SoundManager.play_sound("COOKED_CRAB")

	if score_made > 0:
		EffectManager.score_effect(score_made)
