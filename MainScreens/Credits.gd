extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$MenuAnim.play("Menu")


func _on_Button_pressed():
	get_tree().change_scene("res://MainScreens/Menu.tscn")
