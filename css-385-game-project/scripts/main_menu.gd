extends Node2D

@onready var start_menu: Node2D = $"Start menu"
@onready var save_selection: Node2D = $"Save selection"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	to_start()


func to_start():
	start_menu.visible = true
	save_selection.visible = false
	print("to start")


func to_saves():
	start_menu.visible = false
	save_selection.visible = true
	print("to saves")


func _on_start_button_pressed() -> void:
	to_saves()


func _on_back_pressed() -> void:
	to_start()


func _on_select_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map_screen.tscn")
