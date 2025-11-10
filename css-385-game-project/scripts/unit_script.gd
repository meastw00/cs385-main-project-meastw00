extends Area2D

@onready var cooldown: Timer = $Cooldown

const SPEED = 60

var team
var direction
var health
var attack
var curr_target = null
var target_queue: Array[Area2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = team

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if is_instance_valid(curr_target):
		#direction = 0
	#else:
		#direction = team
	position.x += direction * SPEED * delta


func _on_area_entered(enemy: Node2D) -> void:
	direction = 0
	if curr_target != null:
		target_queue.append(enemy)
	else:
		curr_target = enemy
		_attack()


func _on_cooldown_timeout() -> void:
	if is_instance_valid(curr_target):
		_attack()
	else:
		_next_target()


func _attack() -> void:
	if curr_target.health < attack:
		curr_target.queue_free()
		cooldown.start()
	else:
		curr_target.health -= attack
		cooldown.start()

func _next_target() -> void:
	while target_queue.size() > 0:
		curr_target = target_queue.pop_front()
		if is_instance_valid(curr_target):
			_attack()
			return
	curr_target = null
	direction = team
