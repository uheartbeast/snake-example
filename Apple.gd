extends Node2D

const GRID_SIZE = 32

func update_position():
	var new_position = Vector2(randi() % (640-GRID_SIZE), randi() % (640-GRID_SIZE))
	var snapped_position = new_position.snapped(Vector2(GRID_SIZE, GRID_SIZE))
	global_position = snapped_position
