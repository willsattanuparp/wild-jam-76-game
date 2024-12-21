class_name Enemy extends CharacterBody2D

enum ATTACK_STATE { IDLE, PHASE_ONE, PHASE_TWO, PHASE_THREE, PHASE_FINAL }
enum MOVEMENT_STATE {  IDLE, PACING, CHANGE_POSITION  }

var current_attack_state : ATTACK_STATE = ATTACK_STATE.PHASE_ONE
var current_movement_state : MOVEMENT_STATE = MOVEMENT_STATE.CHANGE_POSITION

@export var animation_player: AnimationPlayer

var local_position = 0
@export var pacing_boundry: Vector2 = Vector2(100,-100)
@export var vision_ray: RayCast2D
@export var player: Player
@export var current_landing: LandingPoint
@export var jump_locations_holder: Node2D
@onready var jump_locations = jump_locations_holder.get_children()


@export var burst_projectile: PackedScene
@export var burst_projectile_resource: Resource
@export var throw_projectile: PackedScene
@export var throw_projectile_resource: Resource
@export var spiral_projectile: PackedScene
@export var spiral_projectile_resource: Resource
@export var consecutive_projectile: PackedScene
@export var consecutive_projectile_resource: Resource
@export var projectile_nodes_holder: Node2D

var direction = Vector2.RIGHT

#for leap change
var changed_position = false
var target_pos = Vector2.ZERO
var gravity_during_leap = 600
var leaping = false
var jumping = false

var facing_right = false
@export var enemy_sprite: Sprite2D

var GRAVITY = 4000
var JUMP_FORCE = -800
var ACCELERATION = 20
var FRICTION = 20
var MAX_SPEED = 200

var health = 100

var initial_attack_timer: float = 5.0
var attack_timer = initial_attack_timer

signal victory()
signal update_hp_bar(value)

func _ready() -> void:
	pacing_boundry = current_landing.get_boundries()

func _process(delta: float) -> void:
	attack_state_matcher(delta)

func _physics_process(delta: float) -> void:
	movement_state_matcher(delta)
	#Gravity effect - leaping will have its own gravity
	if !is_on_floor() and !leaping:
		velocity.y += GRAVITY * delta
	elif leaping:
		velocity.y += gravity_during_leap * delta
	if velocity.y == 0 and is_on_floor():
		jumping = false
	#print(velocity)
	if current_movement_state != MOVEMENT_STATE.CHANGE_POSITION:
		velocity.x = lerp(velocity.x, direction.x * MAX_SPEED, ACCELERATION * delta if direction.x != 0 else FRICTION * delta)
	var facing_dir = global_position.x - player.global_position.x
	if facing_dir < 0 and !facing_right:
		flip_player(true)
	elif facing_dir > 0 and facing_right:
		flip_player(false)
	movement_animations(4.0)
	move_and_slide()

func movement_animations(_anim_speed):
	pass

func jump(jump_force,anim_speed):
	jumping = true
	velocity.y = jump_force
	play_jump_animation(anim_speed)

func play_jump_animation(_anim_speed):
	pass

func attack_state_matcher(delta: float):
	match current_attack_state:
		ATTACK_STATE.IDLE:
			attack_state_idle(delta)
		ATTACK_STATE.PHASE_ONE:
			attack_state_phase_one(delta)
		ATTACK_STATE.PHASE_TWO:
			attack_state_phase_two(delta)
		ATTACK_STATE.PHASE_THREE:
			attack_state_phase_three(delta)
		ATTACK_STATE.PHASE_FINAL:
			attack_state_phase_final(delta)
	#printerr("no attack state found")

func movement_state_matcher(delta: float):
	match current_movement_state:
		MOVEMENT_STATE.IDLE:
			movement_state_idle(delta)
		MOVEMENT_STATE.PACING:
			movement_state_pacing(delta)
		MOVEMENT_STATE.CHANGE_POSITION:
			movement_state_change_position(delta)
	#printerr("no movement state found")

func change_attack_state(new_state: ATTACK_STATE):
	current_attack_state = new_state

func change_movement_state(new_state: MOVEMENT_STATE):
	current_movement_state = new_state



func attack_state_idle(_delta):
	pass

func attack_state_phase_one(delta):
	if attack_timer > 0:
		attack_timer -= delta
	else:
		attack_timer = initial_attack_timer
		var rand = randf()
		if rand < 0.2:
			print("throw")
			attack_consecutive(0,0,Vector2.ZERO,1.2,true,.8,3) 
		elif rand < 0.6:
			print("spiral")
			attack_spiral(8,.3)
		elif rand < 0.9:
			print("burst")
			attack_burst(10)
		else:
			print("idle")
		
	if health < 70:
		initial_attack_timer = 5.0
		attack_timer = initial_attack_timer
		change_attack_state(ATTACK_STATE.PHASE_TWO)

func attack_state_phase_two(delta):
	if attack_timer > 0:
		attack_timer -= delta
	else:
		attack_timer = initial_attack_timer
		var rand = randf()
		if rand < 0.2:
			pass 
		if rand < 0.6:
			pass 
		if rand < 0.9:
			pass 
		else:
			pass
	if health < 40:
		initial_attack_timer = 5.0
		attack_timer = initial_attack_timer
		change_attack_state(ATTACK_STATE.PHASE_THREE)

func attack_state_phase_three(delta):
	if attack_timer > 0:
		attack_timer -= delta
	else:
		attack_timer = initial_attack_timer
		var rand = randf()
		if rand < 0.2:
			pass 
		if rand < 0.6:
			pass 
		if rand < 0.9:
			pass 
		else:
			pass
	if health < 15:
		initial_attack_timer = 5.0
		attack_timer = initial_attack_timer
		change_attack_state(ATTACK_STATE.PHASE_FINAL)

func attack_state_phase_final(delta):
	if attack_timer > 0:
		attack_timer -= delta
	else:
		attack_timer = initial_attack_timer
		var rand = randf()
		if rand < 0.2:
			pass 
		if rand < 0.6:
			pass 
		if rand < 0.9:
			pass 
		else:
			pass

#movement state methods
func movement_state_idle(_delta):
	direction.x = 0
	if is_on_floor() and randf() < 0.001:
		jump(JUMP_FORCE, 2.0)
	if randf() < 0.01:
		change_movement_state(MOVEMENT_STATE.PACING)


func movement_state_pacing(delta):
	if randf() < 0.01:
		direction.x *= -1
	#TODO: Change to global position
	if global_position.x <= pacing_boundry.x:
		direction.x = 1
	elif global_position.x >= pacing_boundry.y:
		direction.x = -1
	elif direction.x == 0:
		direction.x = 1
	local_position += direction.x * MAX_SPEED * delta
	if is_on_floor() and randf() < 0.001:
		jump(JUMP_FORCE, 2.0)
	if randf() < 0.0001:
		change_movement_state(MOVEMENT_STATE.IDLE)

func movement_state_change_position(_delta):
	if !changed_position:
		leaping = true
		var marker = current_landing
		#make sure it doesnt get the same landing, otherwise reroll
		while marker == current_landing:
			marker = jump_locations[randi() % jump_locations.size()]
		print(marker.id)
		var pos_change_leap_time = current_landing.get_time_to_location(marker.id)
		target_pos = marker.global_position
		pacing_boundry = marker.get_boundries()
		current_landing = marker
		
		var distance_x = target_pos.x - global_position.x
		var distance_y = target_pos.y - global_position.y
	
	
		var velocity_x = distance_x / (pos_change_leap_time)
		var velocity_y = (distance_y / pos_change_leap_time) - (0.5 * gravity_during_leap * pos_change_leap_time)
	
		direction.x = sign(velocity_x)
		velocity.x = velocity_x
		jump(velocity_y, 1.2 / pos_change_leap_time)
		changed_position = true
	if abs(global_position.x - target_pos.x) < 5 and is_on_floor():
		leaping = false
		change_movement_state(MOVEMENT_STATE.IDLE)

func jump_to_marker():
	pass

func detect_obstacle_in_front() -> bool:
	return false


func instantiate_projectile_scene(scene: PackedScene,res: Resource, point: Vector2 = Vector2.ZERO) -> Projectile:
	if scene == null or res == null:
		return
	var projectile = throw_projectile.instantiate() as Projectile
	initialize_spawning_projectile_from_resource(projectile,throw_projectile_resource)
	return projectile

func attack_throw(direction: Vector2,direct_at_player: bool, point: Vector2 = Vector2.ZERO):
	var projectile = instantiate_projectile_scene(throw_projectile,throw_projectile_resource,point)
	var attack_source = point if point != Vector2.ZERO else global_position
	if direct_at_player:
		projectile.velocity = (player.global_position - global_position).normalized()
	else:
		projectile.velocity = direction.normalized()
	projectile.position = attack_source
	projectile_nodes_holder.add_child(projectile)

func attack_burst(burst_number: int,point: Vector2 = Vector2.ZERO):
	var angle_inc = TAU / burst_number
	for i in burst_number:
		var angle = angle_inc * i
		var projectile = instantiate_projectile_scene(burst_projectile,burst_projectile_resource,point)
		projectile.velocity = Vector2(cos(angle),sin(angle))
		projectile.position = position + point
		#offset spawn-in so the collisions work
		projectile.ignore_first_bounce_collision = true
		#if collide_on_floor:
			#if projectile.affected_by_hard_floor:
				#set_collision_mask_value(2,false)
				#collision_ray.set_collision_mask_value(2,false)
			#if projectile.affected_by_soft_floor:
				#set_collision_mask_value(3,false)
				#collision_ray.set_collision_mask_value(3,false)
		projectile_nodes_holder.call_deferred("add_child",projectile)

func attack_spiral(spiral_number: int, time_between_projectiles: float, point: Vector2 = Vector2.ZERO):
	var angle_inc = TAU / spiral_number
	for i in spiral_number:
		var angle = angle_inc * i
		var projectile = instantiate_projectile_scene(spiral_projectile,spiral_projectile_resource,point)
		projectile.velocity = Vector2(cos(angle),sin(angle))
		projectile.position = position + point
		#offset spawn-in so the collisions work
		projectile.ignore_first_bounce_collision = true
		#if collide_on_floor:
			#if projectile.affected_by_hard_floor:
				#set_collision_mask_value(2,false)
				#collision_ray.set_collision_mask_value(2,false)
			#if projectile.affected_by_soft_floor:
				#set_collision_mask_value(3,false)
				#collision_ray.set_collision_mask_value(3,false)
		projectile_nodes_holder.call_deferred("add_child",projectile)
		await get_tree().create_timer(time_between_projectiles).timeout

func attack_consecutive(type: int,number_of_projectiles: int,direction: Vector2, time_between_projectiles: float, direct_at_player: bool, time_between_attacks: float, number_of_attacks: int, point: Vector2 = Vector2.ZERO):
	var projectile = instantiate_projectile_scene(consecutive_projectile,consecutive_projectile_resource,point)
	for i in number_of_attacks:
		match type:
			0:
				attack_throw(direction,direct_at_player,point)
			1:
				attack_burst(number_of_projectiles,point)
			2:
				attack_spiral(number_of_projectiles,time_between_projectiles,point)
			_:
				printerr("No type!")
		await get_tree().create_timer(time_between_attacks).timeout

func damage(value):
	health -= value
	clamp(health,0,100)
	update_hp_bar.emit(health)
	if health <= 0:
		victory.emit()

func flip_player(face_right):
	facing_right = face_right
	enemy_sprite.scale.x *= -1

func _on_change_position_timer_timeout() -> void:
	if randf() < .5:
		print("changing")
		changed_position = false
		change_movement_state(MOVEMENT_STATE.CHANGE_POSITION)

func initialize_spawning_projectile_from_resource(proj: Projectile, projectile_stats: Resource):
	proj.initial_speed = projectile_stats.initial_speed
	proj.velocity = projectile_stats.velocity
	proj.gravity_effect = projectile_stats.gravity_effect
	proj.affected_by_gravity = projectile_stats.affected_by_gravity
	proj.bounces_off_floor = projectile_stats.bounces_off_floor
	proj.affected_by_hard_floor = projectile_stats.affected_by_hard_floor
	proj.affected_by_soft_floor = projectile_stats.affected_by_soft_floor
#explosion logic
	proj.explodes_on_floor = projectile_stats.explodes_on_floor
#TODO explode from timer
	proj.explode_from_timer = projectile_stats.explode_from_timer
	proj.explosion_timer = projectile_stats.explosion_timer

	proj.number_of_projectiles_in_explosion = projectile_stats.number_of_projectiles_in_explosion
	proj.projectile_scene = projectile_stats.projectile_scene
	proj.projectile_stats = projectile_stats.projectile_stats
