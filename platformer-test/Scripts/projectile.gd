class_name Projectile extends Area2D


const GRAVITY = 5

@export var initial_speed = 600
@export var velocity = Vector2.RIGHT
@export var affected_by_gravity: bool = false
@export var bounces_off_floor: bool = false
@export var affected_by_hard_floor: bool = false
@export var affected_by_soft_floor: bool = false
@onready var speed = initial_speed

var is_moving = true

#explosion logic
@export var explodes_on_floor: bool = false
@export var explode_from_timer: bool = false
@export var number_of_projectiles_in_explosion: int = 6
@export var projectile_scene :PackedScene

#bounce logic
@export var collision_ray: RayCast2D
@export var raycast_length: float = 15

var freezing = false
var freeze_rate = 5


func _ready() -> void:
	calculate_ray()
	if affected_by_hard_floor:
		pass
	if affected_by_soft_floor:
		pass

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
	if is_moving:
		projectile_move(delta)

func projectile_move(delta: float):
	position += velocity.normalized() * speed * delta
	if affected_by_gravity:
		velocity.y += GRAVITY * delta

func projectile_explode():
	print("explode projectile then queue free")

func projectile_body_entered(body: Node2D):
	#explodes on the floor
	if body.is_in_group("Floor") and explodes_on_floor:
		is_moving = false
		if projectile_scene != null:
			star_explosion(number_of_projectiles_in_explosion)
		else:
			printerr("projectile not found")
		queue_free()
		print("hit floor")
	#bounces off floor
	if bounces_off_floor and collision_ray.is_colliding() and collision_ray.get_collider().is_in_group("Floor"):
		var collision_normal = collision_ray.get_collision_normal()
		velocity = velocity.bounce(collision_normal)
		calculate_ray()

func star_explosion(number_of_projectiles: int):
	var angle_inc = TAU / number_of_projectiles
	for i in number_of_projectiles:
		var angle = angle_inc * i
		var projectile = projectile_scene.instantiate() as Projectile
		projectile.velocity = Vector2(cos(angle),sin(angle))
		projectile.position = position
		if freezing:
			projectile.freeze()
		get_parent().call_deferred("add_child",projectile)

func calculate_ray():
	collision_ray.target_position = velocity.normalized() * raycast_length
