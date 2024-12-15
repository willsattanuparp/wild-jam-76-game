extends CharacterBody2D

enum ATTACK_STATE { BEGIN }
enum MOVEMENT_STATE { BEGIN }

var current_attack_state : ATTACK_STATE = ATTACK_STATE.BEGIN
var current_movement_state : MOVEMENT_STATE = MOVEMENT_STATE.BEGIN

func _process(delta: float) -> void:
	attack_state_matcher(delta)

func _physics_process(delta: float) -> void:
	movement_state_matcher(delta)

func attack_state_matcher(delta: float):
	match current_attack_state:
		ATTACK_STATE.BEGIN:
			attack_state_begin(delta)

func movement_state_matcher(delta: float):
	match current_movement_state:
		MOVEMENT_STATE.BEGIN:
			movement_state_begin(delta)

func change_attack_state(new_state: ATTACK_STATE):
	current_attack_state = new_state

func change_movement_state(new_state: MOVEMENT_STATE):
	current_movement_state = new_state

func attack_state_begin(delta: float):
	pass

func movement_state_begin(delta: float):
	pass
