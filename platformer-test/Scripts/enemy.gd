extends CharacterBody2D

enum MOVEMENT_STATE { BEGIN }
enum ATTACK_STATE { BEGIN }

var current_movement_state : MOVEMENT_STATE = MOVEMENT_STATE.BEGIN
var current_attack_state : ATTACK_STATE = ATTACK_STATE.BEGIN

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	pass

func movement_state_matcher():
	pass

func attack_state_matcher():
	pass

func change_state():
	pass
