extends Node2D

func _ready():
	$Anim.play("crash")

func _on_Anim_animation_finished():
	queue_free()
