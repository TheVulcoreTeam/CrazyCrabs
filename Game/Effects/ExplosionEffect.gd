extends Node2D

func _ready():
	$AnimatedSprite.play("default")
	SoundManager.play_sound("EXPLOSION")

func _on_AnimatedSprite_animation_finished():
	queue_free()
