class_name Projectile extends Area2D


@export var initial_speed = 600
@export var velocity = Vector2.RIGHT
@onready var speed = initial_speed

var freezing = false
var freeze_rate = 5


func freeze():
	freezing = true
	#print("freezing")
	#set_collision_mask_value(1,false)

func unfreeze():
	freezing = false
	speed = initial_speed

func _on_body_entered(body: Node2D) -> void:
	projectile_body_entered(body)
	if body.is_in_group("Player"):
		body.damage()
		projectile_explode()

func _process(delta: float) -> void:
	if freezing and speed > 0:
		speed -= freeze_rate
	elif speed < 0:
		speed = 0
	projectile_move(delta)

func projectile_move(delta: float):
	position += velocity.normalized() * speed * delta

func projectile_explode():
	print("explode projectile then queue free")

func projectile_body_entered(body: Node2D):
	pass
