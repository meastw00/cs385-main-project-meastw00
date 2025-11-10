extends Node2D

@export var unit_1 : PackedScene = preload("res://scenes/unit_1.tscn")
@export var unit_2 : PackedScene = preload("res://scenes/unit_2.tscn")

func _ready():
	pass

func spawn_unit(type, money, team) -> int:
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
	if team == 1:
		unit.collision_layer = 1 << 1
		unit.collision_mask = 1 << 2
	else:
		unit.collision_layer = 1 << 2
		unit.collision_mask = 1 << 1
	add_child(unit)
	return money
