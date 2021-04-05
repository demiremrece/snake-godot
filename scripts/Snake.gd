extends Node2D

class_name Snake

signal move_triggered(entity, direction)
signal new_tail_segment(segment, segment_pos)
signal body_segment_move(segment, segment_pos)

const SNAKE_SPEED: float = 6.0;
var last_render_time: float = 0;

onready var direction: Vector2 = Vector2()
onready var body_segments: Array = [self]

const scene_tail = preload("res://scenes/Tail.tscn")


func _ready():
	$PlayerInput.connect("input_detected", self, "onInputDetected")
	
func _process(delta):
	var currentTime = OS.get_ticks_msec()
	var seconds_since_last_render = (currentTime - last_render_time) / 1000
	if seconds_since_last_render < (1 / SNAKE_SPEED):
		return

	last_render_time = currentTime
	
	if direction != Vector2(0,0):
		var old_pos_of_front_segment: Vector2 = self.position
		emit_signal("move_triggered", self, direction)
#		direction = Vector2(0,0)
		
		if body_segments.size() > 1:
			for i in range(1 , body_segments.size()):
				var tmp_pos: Vector2 = body_segments[i].position
				emit_signal("body_segment_move", body_segments[i], old_pos_of_front_segment)
				old_pos_of_front_segment = tmp_pos


func onInputDetected(new_direction) -> void:
	if(new_direction != direction * -1):
		direction = new_direction
		print(direction)

func eatFood() -> void:
	var tail_segment: Node2D = scene_tail.instance() as Node2D
	body_segments.append(tail_segment)
	
	emit_signal("new_tail_segment", tail_segment, body_segments[-2].position)
