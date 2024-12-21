class_name LandingPoint extends Node2D

@export var left_bound : Marker2D
@export var right_bound : Marker2D
@export var id : int
@export var time_to_jump_here_from_id : Dictionary
@export var ids_can_jump_to : Array


#TODO: add locations enemy can jump to
func get_id_to_jump_to():
	return ids_can_jump_to[randi() % ids_can_jump_to.size()]


func get_boundries():
	return Vector2(left_bound.global_position.x,right_bound.global_position.x)

func get_time_to_location(loc : int):
	return time_to_jump_here_from_id[loc]
