extends Node2D

var next: Array[Node2D] = []
var prev: Array[Node2D] = []
@export_enum("Straight", "Split", "Merge")
var branch: String
var direction: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if get_children().size() > 0:
		$DirectionSwitch.flip_direction.connect(_on_direction_flip)


func _request_next(team: bool) -> Node2D:
	if team:
		return next[direction]
	else:
		return prev[direction]


func _on_direction_flip() -> void:
	if direction == 0:
		direction = 1
	else:
		direction = 0
