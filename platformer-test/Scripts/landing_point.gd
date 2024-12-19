extends Node2D

@export var left_bound : Marker2D
@export var right_bound : Marker2D
@export var id : int

func get_boundries():
	return Vector2(left_bound.position.x,right_bound.position.x)
