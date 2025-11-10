extends Node2D

@onready var worldmap: Node = $Worldmap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var counter = 0
	var levels = worldmap.get_children()
	while Global.levels > counter:
		levels[counter].visible = true
		counter += 1
	while levels.size() > counter:
		levels[counter].visible = false
		counter += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")
