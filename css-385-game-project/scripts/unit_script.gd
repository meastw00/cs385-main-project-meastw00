extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var cooldown: Timer = $Cooldown
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var sight: Area2D = $Sight
@onready var hurt_sfx: AudioStreamPlayer2D = $HurtSFX

const SPEED = 60


var team: bool
var health: int
var attack: int
var next: Node2D
var rand_y: int = 0
var fighting: bool = false
var target_queue: Array[CharacterBody2D] = []
var attack_queue: Array[CharacterBody2D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nav_agent.velocity_computed.connect(_on_agent_velocity_computed)
	makepath()
	if team:
		sprite.play("Player_walk")
	else:
		sprite.play("Enemy_walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var dir
	if fighting:
		dir = Vector2.ZERO
	else:
		dir = (nav_agent.get_next_path_position() - global_position).normalized()
	var desired_velocity = dir * SPEED
	
	nav_agent.set_velocity(desired_velocity)

func _on_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func makepath() -> void:
	var pos: Vector2
	if target_queue.size() > 0:
		if is_instance_valid(target_queue[0]):
			pos = target_queue[0].global_position
	else:
		pos = next.global_position
		if team:
			pos.x += 10
		else:
			pos.x -= 10
		pos.y += rand_y
	nav_agent.target_position = pos


func _on_update_timeout() -> void:
	_main()

# Main body of the script
func _main() -> void:
	target_queue = _clear_freed(target_queue)
	if fighting:
		attack_queue = _clear_freed(attack_queue)
		if fighting && cooldown.is_stopped():
			_attack()
	else:
		if next.global_position.x <= global_position.x && team:
			next = next._request_next(team)
			var rng = RandomNumberGenerator.new()
			rand_y = rng.randi_range(-20, 20)
		elif next.global_position.x >= global_position.x && !team:
			next = next._request_next(team)
			var rng = RandomNumberGenerator.new()
			rand_y = rng.randi_range(-20, 20)
		makepath()
		if team:
			sprite.play("Player_walk")
		else:
			sprite.play("Enemy_walk")


func _on_sight_body_entered(entity: Node2D) -> void:
	if entity is CharacterBody2D && entity.team != team:
		target_queue.append(entity)

func _on_sight_body_exited(entity: Node2D) -> void:
	if entity is CharacterBody2D && entity.team != team:
		target_queue.erase(entity)

func _on_range_body_entered(entity: Node2D) -> void:
	if entity is CharacterBody2D && entity.team != team:
		attack_queue.append(entity)
		fighting = true

func _on_range_body_exited(entity: Node2D) -> void:
	if entity is CharacterBody2D && entity.team != team:
		attack_queue.erase(entity)


func _attack():
	if is_instance_valid(attack_queue[0]):
		if team:
			sprite.play("Player_fight")
		else:
			sprite.play("Enemy_fight")
		if attack_queue[0].health < attack:
			target_queue.erase(attack_queue[0])
			attack_queue[0].queue_free()
			attack_queue.pop_front()
			cooldown.start()
		else:
			attack_queue[0].health -= attack
			cooldown.start()
		hurt_sfx.play()


func _clear_freed(targets: Array[CharacterBody2D]) -> Array[CharacterBody2D]:
	var i: int = 0
	while i < targets.size():
		if !is_instance_valid(targets[i]):
			targets.remove_at(i)
		else:
			i += 1
	if targets.size() == 0:
		fighting = false
	return targets
