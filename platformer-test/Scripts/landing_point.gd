class_name LandingPoint extends Node2D

@export var left_bound : Marker2D
@export var right_bound : Marker2D
@export var id : int
@export var time_to_jump_here_from_id : Dictionary

func get_boundries():
	return Vector2(left_bound.position.x,right_bound.position.x)

func get_time_to_location(loc : int):
	return time_to_jump_here_from_id[loc]
