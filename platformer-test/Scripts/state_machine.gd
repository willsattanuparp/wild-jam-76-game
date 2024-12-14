extends Node

var states: Dictionary = {}

@export var initial_state: State
var current_state: State


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.state_id] = child
			child.transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state,new_state_name):
	if state != current_state:
		return
	var new_state = states.get(new_state_name.state_id)
	if !new_state:
		return
	if current_state:
		current_state.exit()
	new_state.enter()
