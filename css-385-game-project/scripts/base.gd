extends Area2D

signal low_health()

var health: int
var team: bool

func _ready() -> void:
	health = 10

func _on_body_entered(entity: Node2D) -> void:
	if entity is CharacterBody2D && entity.team != team:
		entity.queue_free()
		health -= 1
		if health == 3:
			emit_signal("low_health")
