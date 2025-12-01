extends Button


signal flip_direction()
var dir = true

func _on_pressed() -> void:
	if dir:
		text = "|\n\\/"
		#text = "down"
		dir = false
	else:
		text = "/\\\n|"
		#text = "up"
		dir = true
	emit_signal("flip_direction")
