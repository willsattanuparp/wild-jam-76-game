class_name Enemy extends CharacterBody2D

enum ATTACK_STATE { IDLE, PHASE_ONE, PHASE_TWO, PHASE_THREE }
enum MOVEMENT_STATE {  IDLE, PACING, CHANGE_POSITION  }

var current_attack_state : ATTACK_STATE = ATTACK_STATE.IDLE
var current_movement_state : MOVEMENT_STATE = MOVEMENT_STATE.IDLE

var local_position = 0
@export var pacing_boundry: Vector2 = Vector2(100,-100)
@export var vision_ray: RayCast2D
@export var player: Player

var direction = Vector2.RIGHT

const GRAVITY = 4000
const JUMP_FORCE = -800
const ACCELERATION = 20
const FRICTION = 20
const MAX_SPEED = 200

func _process(delta: float) -> void:
	attack_state_matcher(delta)

func _physics_process(delta: float) -> void:
	movement_state_matcher(delta)
	#Gravity effect
	print(current_movement_state)
	if !is_on_floor():
		velocity.y += GRAVITY * delta
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
	if randf() < 0.001:
		print("changing")
		change_movement_state(MOVEMENT_STATE.PACING)


func movement_state_pacing(delta):
	if randf() < 0.01:
		direction.x *= -1
	if local_position >= pacing_boundry.x:
		direction.x = -1
	elif local_position <= pacing_boundry.y:
		direction.x = 1
	elif direction.x == 0:
		direction.x = 1
	local_position += direction.x * MAX_SPEED * delta
	if is_on_floor() and randf() < 0.05:
		jump(JUMP_FORCE)
	if randf() < 0.001:
		change_movement_state(MOVEMENT_STATE.IDLE)

func movement_state_change_position(delta):
	pass


func detect_obstacle_in_front() -> bool:
	return false
