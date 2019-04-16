extends "SnakeSegment.gd"

const GRID_SIZE = 32
const Segment = preload("res://SnakeSegment.tscn")

var tail_position = Vector2()
var tail = self
var direction = Vector2.RIGHT
var speed = 0.5 setget set_speed
var score = 0 setget set_score

onready var timer = $Timer
onready var segments = $Segments
onready var scoreLabel = get_parent().get_node("UI/ScoreLabel")

func set_speed(value):
	speed = value
	timer.wait_time = speed

func set_score(value):
	score = value
	scoreLabel.text = "Score: " + str(score)

#warning-ignore:unused_argument
func _process(delta):
	update_direction()

func move():
	update_tail_position()
	var new_location = global_position + direction * GRID_SIZE
	update_position(new_location)

func eat():
	var apple = get_apple_at_point(global_position)
	if apple != null:
		apple.update_position()
		self.speed *= 0.9
		self.score += 10
		add_tail()

func check_for_collision():
	var segment = get_segment_at_point(global_position)
	var arena = Rect2(0, 0, 639, 639)
	if segment != null or not arena.has_point(global_position):
		#warning-ignore:return_value_discarded
		get_tree().reload_current_scene()

func add_tail():
	var segment = Segment.instance()
	segments.add_child(segment)
	segment.global_position = tail_position
	tail.add_segment(segment)
	tail = segment

func update_direction():
	if Input.is_action_pressed("ui_right"):
		self.direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_up"):
		self.direction = Vector2.UP
	elif Input.is_action_pressed("ui_left"):
		self.direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_down"):
		self.direction = Vector2.DOWN

func update_tail_position():
	var segments_array = segments.get_children()
	if segments_array.size() == 0:
		tail_position = global_position
	else:
		tail_position = segments_array.back().global_position

func get_apple_at_point(point):
	var node_list = get_tree().get_nodes_in_group("Apples")
	for node in node_list:
		if node.global_position == point:
			return node
	return null

func get_segment_at_point(point):
	var segments_list = segments.get_children()
	for segment in segments_list:
		if segment.global_position == point:
			return segment
	return null

func _on_Timer_timeout():
	update_direction()
	move()
	eat()
	check_for_collision()
