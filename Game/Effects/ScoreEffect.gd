extends Node2D

onready var label = $Label
var score_text = "+1"
func init(score):
	score_text = "+"+str(score)
#	label.text = "HOLA"

func _ready():
	label.text = score_text
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
