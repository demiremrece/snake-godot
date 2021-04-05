extends Node2D

class_name PlayerInput

var direction = Vector2(0,0);
signal input_detected(direction)

func _input(event):
	if (Input.is_action_pressed("move_up")):
		direction = Vector2(0,-1)
		emit_signal("input_detected",direction)
		pass
	elif (Input.is_action_pressed("move_down")):
		direction = Vector2(0,1)
		emit_signal("input_detected",direction)
		pass
	elif (Input.is_action_pressed("move_left")):
		direction = Vector2(-1,0)
		emit_signal("input_detected",direction)
		pass
	elif (Input.is_action_pressed("move_right")):
		direction = Vector2(1,0)
		emit_signal("input_detected",direction)
		pass
		
