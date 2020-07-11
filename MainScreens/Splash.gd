extends Node2D

func _ready():
	$Splash.play("Splash")
	SoundManager.play_sound("VULCORE_SPLASH", 20.0)

func _on_Splash_animation_finished():
	$Splash/Anim.play("Hide")

func _on_Anim_animation_finished(anim_name):
	get_tree().change_scene("res://MainScreens/Menu.tscn")
