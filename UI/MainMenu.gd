extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass

func _on_Play_pressed():
	var _target = get_tree().change_scene("res://Maze/Maze.tscn")

func _on_Quit_pressed():
	get_tree().quit()
