extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var cooldown: Timer = $Cooldown
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sight: Area2D = $Sight
@onready var range: Area2D = $Range
@onready var hurt_sfx: AudioStreamPlayer2D = $HurtSFX

const SPEED = 60


var team: bool
var health: int
var attack: int
var next: Node2D
var fighting: bool = false
var curr_target: CharacterBody2D = null
var target_queue: Array[CharacterBody2D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	makepath()
	if team:
		sprite.play("Player_walk")
	else:
		sprite.play("Enemy_walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * SPEED
	move_and_slide()


func makepath() -> void:
	var target: Node2D
	if curr_target == null:
		target = next
	else:
		target = curr_target
	var rng = RandomNumberGenerator.new()
	var pos: Vector2 = target.global_position
	pos.y += rng.randi_range(-10, 10)
	nav_agent.target_position = pos


func _on_update_timeout() -> void:
	if !fighting:
		makepath()


func _on_sight_body_entered(entity: Node2D) -> void:
	if entity is CharacterBody2D && entity.team != team:
		if curr_target != null:
			target_queue.append(entity)
		else:
			curr_target = entity


func _on_range_body_entered(entity: Node2D) -> void:
	#var entity: CharacterBody2D = body.get_parent()
	if entity is CharacterBody2D && entity.team != team && cooldown.is_stopped():
		_attack()


func _attack():
	if is_instance_valid(curr_target):
		fighting = true
		if team:
			sprite.play("Player_fight")
		else:
			sprite.play("Enemy_fight")
		if curr_target.health < attack:
			curr_target.queue_free()
			cooldown.start()
		else:
			curr_target.health -= attack
			cooldown.start()
		hurt_sfx.play()
	else:
		_next_target()


func _on_cooldown_timeout() -> void:
	if is_instance_valid(curr_target):
		_attack()
	else:
		_next_target()


func _next_target() -> void:
	while target_queue.size() > 0:
		if is_instance_valid(target_queue.front()):
			curr_target = target_queue.pop_front()
			_attack()
			return
	curr_target = null
	fighting = false
	if team:
		sprite.play("Player_walk")
	else:
		sprite.play("Enemy_walk")
