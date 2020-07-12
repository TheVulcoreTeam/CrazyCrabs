extends Node2D

onready var label = $Label

func init(score):
	label.text = '+'+str(score)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
