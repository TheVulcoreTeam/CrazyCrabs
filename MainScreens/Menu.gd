extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuAnim.play("Menu")
	$Version.text = Main.VERSION
	
	if OS.get_name() == "HTML5":
		$Exit.visible = false


func _on_Start_pressed():
	get_tree().change_scene("res://Game/Stage/" + Main.STAGE_VERSION + ".tscn")


func _on_Scores_pressed():
	get_tree().change_scene("res://MainScreens/EndLevel.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func _on_Credits_pressed():
	get_tree().change_scene("res://MainScreens/Credits.tscn")


func _on_close_pressed():
	$Tutorial.visible = false


func _on_Help_pressed():
	$Tutorial.visible = true


func _on_TouchScreenButton_pressed():
	Main.easter_egg = true
	SoundManager.play_sound("AARGH_" + str(int(round(rand_range(1, 5)))), 1, false)
