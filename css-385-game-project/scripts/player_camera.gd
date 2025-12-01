extends Camera2D

var bound_x
var bound_y


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_pos = global_position
	if Input.is_action_pressed("camera_up"):
		new_pos.y += -5
	if Input.is_action_pressed("camera_left"):
		new_pos.x += -5
	if Input.is_action_pressed("camera_right"):
		new_pos.x += 5
	if Input.is_action_pressed("camera_down"):
		new_pos.y += 5
	# clamp it BEFORE assigning
	var camera_size = get_viewport_rect().size
	new_pos.x = clamp(new_pos.x, limit_left + (camera_size.x/2), limit_right - (camera_size.x/2))
	new_pos.y = clamp(new_pos.y, limit_top + (camera_size.y/2), limit_bottom - (camera_size.y/2))
	global_position = new_pos
