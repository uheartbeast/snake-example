extends Node2D

var next_segment = null

func update_position(new_position):
	var previous_position = global_position
	global_position = new_position
	if next_segment != null:
		next_segment.update_position(previous_position)

func add_segment(segment):
	next_segment = segment