extends KinematicBody2D

var cover_off := false

func _on_TouchArea_pressed():
	if not $Cover/Anim.is_playing():
		cover_off = not cover_off
		
		if cover_off:
			$Cover/Anim.play("CoverOn")
			$Collision.disabled = true
		else:
			$Cover/Anim.play_backwards("CoverOn")
			$Collision.disabled = false

func _on_CaptureArea_body_entered(body):
	if cover_off and body is GCrab:
		body = body as GCrab
		body.capture()
