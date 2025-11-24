extends Node2D

@export var unit_1 : PackedScene = preload("res://scenes/unit_1.tscn")
@export var unit_2 : PackedScene = preload("res://scenes/unit_2.tscn")
@onready var spawn_sfx: AudioStreamPlayer2D = $SpawnSFX

func _ready():
	pass

func spawn_unit(type: int, money: int, team: bool, path: Node2D) -> int:
	var unit
	if type == 1:
		if money >= 10:
			money -= 10
			unit = unit_1.instantiate()
			unit.health = 2
			unit.attack = 1
		else:
			print("Not enough money")
			return money
	else:
		if money >= 20:
			money -= 20
			unit = unit_2.instantiate()
			unit.health = 5
			unit.attack = 2
		else:
			print("Not enough money")
			return money
	unit.team = team
	unit.next = path
	add_child(unit)
	spawn_sfx.play()
	return money
