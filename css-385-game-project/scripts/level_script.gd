extends Node

@onready var money_count: Label = $MoneyCount
@onready var player_health: Label = $PlayerHealth
@onready var enemy_health: Label = $EnemyHealth
@onready var player_base: Area2D = $PlayerBase
@onready var enemy_base: Area2D = $EnemyBase
@onready var path_tree: Node2D = $PathTree
@onready var music: AudioStreamPlayer2D = $Music

var player_money: int = 10
var enemy_money: int = 0
var path_start: Node2D = null
var path_end: Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.stream = preload("res://assets/music/Sketchbook 2024-08-21.ogg")
	music.play()
	$UnitSelect.spawn_unit.connect(_on_spawn_unit)
	player_base.low_health.connect(_player_low_health)
	player_base.team = true
	enemy_base.team = false
	path_start = path_tree.start
	path_end = path_tree.end

func _process(delta: float) -> void:
	if player_base.health <= 0:
		get_tree().change_scene_to_file("res://scenes/map_screen.tscn")
	if enemy_base.health <= 0:
		Global.levels += 1
		get_tree().change_scene_to_file("res://scenes/map_screen.tscn")
	player_health.text = "Health: " + str(player_base.health)
	enemy_health.text = "Health: " + str(enemy_base.health)

func _on_spawn_unit(data):
	player_money = $PSpawner.spawn_unit(data, player_money, true, path_end)

func _on_timer_timeout() -> void:
	player_money += 1
	enemy_money += 1
	var rng = RandomNumberGenerator.new()
	if enemy_money == 10 && (rng.randi_range(0, 1) == 1 || true):
		enemy_money = $ESpawner.spawn_unit(1, enemy_money, false, path_start)
	elif enemy_money >= 20:
		enemy_money = $ESpawner.spawn_unit(2, enemy_money, false, path_start)
	money_count.text = "Money: " + str(player_money)

func _player_low_health() -> void:
	music.stream = preload("res://assets/music/Sketchbook 2024-02-07.ogg")
	music.play()
