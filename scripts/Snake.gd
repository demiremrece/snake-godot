extends Node2D

class_name Snake

signal move_triggered(entity, direction)
const SNAKE_SPEED: int = 5;
var last_render_time: int = 0;

onready var direction: Vector2 = Vector2()

func _ready():
	$PlayerInput.connect("input_detected", self, "onInputDetected")
	
func _process(delta):
	
	var seconds_since_last_render = (delta - last_render_time) / 1000
	if seconds_since_last_render < 1 / SNAKE_SPEED:
		pass
		
	last_render_time = delta
	
	if direction != Vector2(0,0):
		emit_signal("move_triggered", self, direction)
		direction = Vector2(0,0)

func onInputDetected(new_direction) -> void:
	if(new_direction != direction * -1):
		direction = new_direction
		print(direction)
