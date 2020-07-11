extends Node2D

var cover_on := false


func _on_TouchArea_pressed():
	if not $Cover/Anim.is_playing():
		cover_on = not cover_on
		
		if cover_on:
			$Cover/Anim.play("CoverOn")
		else:
			$Cover/Anim.play_backwards("CoverOn")
