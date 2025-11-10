extends Area2D

var health

func _ready() -> void:
	health = 10

func _on_area_entered(enemy: Node2D) -> void:
	enemy.queue_free()
	health -= 1
