class_name Projectile extends Area2D


@export var gravity_effect: float = 5.0
@onready var current_gravity = gravity_effect

@export var initial_speed: int = 600
@export var velocity: Vector2 = Vector2.RIGHT
@export var collision_shape: CollisionShape2D

@export var affected_by_gravity: bool = false
@export var bounces_off_floor: bool = false
@export var affected_by_hard_floor: bool = false
@export var affected_by_soft_floor: bool = false
@onready var speed = initial_speed

var is_moving = true

#explosion logic
@export var explodes_on_floor: bool = false
#TODO explode from timer
@export var explode_from_timer: bool = false
@export var explosion_timer: float = 4.0

@export var number_of_projectiles_in_explosion: int = 6
@export var projectile_scene: PackedScene
@export var projectile_stats: Resource

#bounce logic
@export var collision_ray: RayCast2D
var recalculate_ray_counter = 0
var recalculate_ray_frames = 6
@onready var raycast_length: float = collision_shape.shape.radius * 1.5

var freezing = false
var frozen = false
var unfreezing = false
var freeze_rate = 500.0
var unfreeze_rate = 500.0
var frozen_timer = 4.0
var gravity_freeze_rate = 0.0

func _ready() -> void:
	calculate_ray()
	if affected_by_hard_floor:
		set_collision_mask_value(2,true)
		collision_ray.set_collision_mask_value(2,true)
	if affected_by_soft_floor:
		set_collision_mask_value(3,true)
		collision_ray.set_collision_mask_value(3,true)
	if affected_by_gravity:
		gravity_freeze_rate = gravity_effect / (speed / freeze_rate)

func freeze():
	freezing = true
	print("freezing")
	#set_collision_mask_value(1,false)

func unfreeze():
	frozen = false
	unfreezing = true

func _on_body_entered(body: Node2D) -> void:
	projectile_body_entered(body)
	if body.is_in_group("Player"):
		body.damage()
		projectile_explode()

func _process(delta: float) -> void:
	#freezing logic
	if freezing:
		if speed > 0:
			speed -= freeze_rate * delta
			current_gravity -= gravity_freeze_rate * delta
		if speed < 0:
			speed = 0
			current_gravity = 0
		if speed == 0:
			freezing = false
			frozen = true
			print("frozen")
	if frozen:
		if frozen_timer > 0:
			frozen_timer -= delta
		elif frozen_timer <= 0:
			unfreeze()
	if unfreezing:
		if speed < initial_speed:
			speed += unfreeze_rate * delta
			current_gravity += gravity_freeze_rate * delta
		if speed > initial_speed:
			speed = initial_speed
			current_gravity = gravity_effect
		if speed == initial_speed:
			unfreezing = false
	#explosion based on timer
	if explode_from_timer:
		if explosion_timer > 0:
			explosion_timer -= delta
		elif explosion_timer <= 0:
			if projectile_scene != null:
				star_explosion(number_of_projectiles_in_explosion)
			else:
				printerr("projectile not found")
			queue_free()
	#print("grav:" + str(current_gravity))
	#print("speed:" + str(speed))
	if is_moving:
		projectile_move(delta)

func projectile_move(delta: float):
	position += velocity.normalized() * speed * delta
	if affected_by_gravity:
		velocity.y += current_gravity * delta
	#print(velocity)
	if !frozen and recalculate_ray_counter % recalculate_ray_frames == 0:
		calculate_ray()
	recalculate_ray_counter += 1

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
	#bounces off floor
	print(collision_ray.is_colliding())
	if bounces_off_floor and collision_ray.is_colliding() and collision_ray.get_collider().is_in_group("Floor"):
		print("collide")
		var collision_normal = collision_ray.get_collision_normal()
		velocity = velocity.bounce(collision_normal)
		calculate_ray()

func star_explosion(number_of_projectiles: int):
	var angle_inc = TAU / number_of_projectiles
	for i in number_of_projectiles:
		var angle = angle_inc * i
		var projectile = projectile_scene.instantiate() as Projectile
		initialize_spawning_projectile_from_resource(projectile)
		projectile.velocity = Vector2(cos(angle),sin(angle))
		projectile.position = position
		if freezing:
			projectile.freeze()
		get_parent().call_deferred("add_child",projectile)

func calculate_ray():
	collision_ray.target_position = velocity.normalized() * raycast_length

func initialize_spawning_projectile_from_resource(proj: Projectile):
	proj.initial_speed = projectile_stats.initial_speed
	proj.velocity = projectile_stats.velocity
	proj.gravity_effect = projectile_stats.gravity_effect
	proj.affected_by_gravity = projectile_stats.affected_by_gravity
	proj.bounces_off_floor = projectile_stats.bounces_off_floor
	proj.affected_by_hard_floor = projectile_stats.affected_by_hard_floor
	proj.affected_by_soft_floor = projectile_stats.affected_by_soft_floor
#explosion logic
	proj.explodes_on_floor = projectile_stats.explodes_on_floor
#TODO explode from timer
	proj.explode_from_timer = projectile_stats.explode_from_timer
	proj.explosion_timer = projectile_stats.explosion_timer

	proj.number_of_projectiles_in_explosion = projectile_stats.number_of_projectiles_in_explosion
	proj.projectile_scene = projectile_stats.projectile_scene
