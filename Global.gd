extends Node

onready var timer = get_node("/root/Game/Timer")
onready var label = get_node("/root/Game/Label")

func _ready():
	timer.start(100)
	pause_mode = PAUSE_MODE_PROCESS
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	label.set_text("Time Remaining: " + str(timer.get_time_left()))

func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		#get_tree().quit()
		var menu = get_node_or_null("/root/Game/Menu")
		if menu != null:
			if not menu.visible:
				menu.show()
				get_tree().paused = true
			else:
				menu.hide()
				get_tree().paused = false
