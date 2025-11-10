extends Node

@onready var money_count: Label = $MoneyCount
@onready var player_health: Label = $PlayerHealth
@onready var enemy_health: Label = $EnemyHealth
@onready var player_base: Area2D = $PlayerBase
@onready var enemy_base: Area2D = $EnemyBase

var player_money = 10
var enemy_money = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UnitSelect.spawn_unit.connect(_on_spawn_unit)
	player_base.collision_mask = 1 << 2
	enemy_base.collision_mask = 1 << 1

func _process(delta: float) -> void:
	if player_base.health <= 0:
		get_tree().change_scene_to_file("res://scenes/map_screen.tscn")
	if enemy_base.health <= 0:
		Global.levels += 1
		get_tree().change_scene_to_file("res://scenes/map_screen.tscn")
	player_health.text = "Health: " + str(player_base.health)
	enemy_health.text = "Health: " + str(enemy_base.health)

func _on_spawn_unit(data):
	player_money = $PSpawner.spawn_unit(data, player_money, 1)

func _on_timer_timeout() -> void:
	player_money += 1
	enemy_money += 1
	var rng = RandomNumberGenerator.new()
	if enemy_money == 10 && rng.randi_range(0, 1) == 1:
		enemy_money = $ESpawner.spawn_unit(1, enemy_money, -1)
	elif enemy_money >= 20:
		enemy_money = $ESpawner.spawn_unit(2, enemy_money, -1)
	money_count.text = "Money: " + str(player_money)
