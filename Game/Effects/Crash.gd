extends Node2D

func _ready():
	if rand_range(-1, 1) > 0:
		$Anim.play("Crash1")
	else:
		$Anim.play("Crash2")
		

func _on_Anim_animation_finished():
	queue_free()
