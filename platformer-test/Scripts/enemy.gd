class_name Enemy extends CharacterBody2D

enum ATTACK_STATE { IDLE, PHASE_ONE, PHASE_TWO, PHASE_THREE }
enum MOVEMENT_STATE {  IDLE, PACING, CHANGE_POSITION  }

var current_attack_state : ATTACK_STATE = ATTACK_STATE.IDLE
var current_movement_state : MOVEMENT_STATE = MOVEMENT_STATE.CHANGE_POSITION

var local_position = 0
@export var pacing_boundry: Vector2 = Vector2(100,-100)
@export var vision_ray: RayCast2D
@export var player: Player
@export var current_landing: LandingPoint
@export var jump_locations_holder: Node2D
@onready var jump_locations = jump_locations_holder.get_children()

var direction = Vector2.RIGHT

#for leap change
var changed_position = false
var target_pos = Vector2.ZERO
var gravity_during_leap = 600
var leaping = false

const GRAVITY = 4000
const JUMP_FORCE = -800
const ACCELERATION = 20
const FRICTION = 20
const MAX_SPEED = 200

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
	#print(velocity)
	if current_movement_state != MOVEMENT_STATE.CHANGE_POSITION:
		velocity.x = lerp(velocity.x, direction.x * MAX_SPEED, ACCELERATION * delta if direction.x != 0 else FRICTION * delta)
	move_and_slide()

func jump(jump_force):
	velocity.y = jump_force

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


#attack state methods
func attack_state_begin(delta: float):
	pass

func movement_state_begin(delta: float):
	pass

func attack_state_idle(delta):
	pass

func attack_state_phase_one(delta):
	pass

func attack_state_phase_two(delta):
	pass

func attack_state_phase_three(delta):
	pass

#movement state methods
func movement_state_idle(delta):
	direction.x = 0
	if is_on_floor() and randf() < 0.001:
		jump(JUMP_FORCE)
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
	if is_on_floor() and randf() < 0.01:
		jump(JUMP_FORCE)
	if randf() < 0.0001:
		change_movement_state(MOVEMENT_STATE.IDLE)

func movement_state_change_position(delta):
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
		jump(velocity_y)
		changed_position = true
	if abs(global_position.x - target_pos.x) < 5 and is_on_floor():
		leaping = false
		change_movement_state(MOVEMENT_STATE.IDLE)

func jump_to_marker():
	pass

func detect_obstacle_in_front() -> bool:
	return false


func _on_change_position_timer_timeout() -> void:
	if randf() < .5:
		print("changing")
		changed_position = false
		change_movement_state(MOVEMENT_STATE.CHANGE_POSITION)
