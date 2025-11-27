extends Node2D

signal spawn_unit(data)

func _on_spawn_1_pressed() -> void:
	emit_signal("spawn_unit", 1)


func _on_spawn_2_pressed() -> void:
	emit_signal("spawn_unit", 2)
