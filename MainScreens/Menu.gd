extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Start_pressed():
	get_tree().change_scene("res://Game/Stage/Stage.tscn")



func _on_Scores_pressed():
	get_tree().change_scene("res://MainScreens/EndLevel.tscn")

