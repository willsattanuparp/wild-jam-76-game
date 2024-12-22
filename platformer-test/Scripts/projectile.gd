class_name Projectile extends Area2D


@export var proj_sprite: Sprite2D
@export var gravity_effect: float = 5.0
@onready var current_gravity = gravity_effect

@export var initial_speed: int = 600
@export var velocity: Vector2 = Vector2.RIGHT
@export var collision_shape: CollisionShape2D

@export var affected_by_gravity: bool = false
@export var bounces_off_floor: bool = false
#@export var bounce_speed_dampen: float = 1.0
@export var affected_by_hard_floor: bool = false
@export var affected_by_soft_floor: bool = false
@onready var speed = initial_speed

#used to stop the main projectile after explosion
var is_moving = true

#explosion logic
@export var explodes_on_floor: bool = false
#TODO explode from timer
@export var explode_from_timer: bool = false
@export var explosion_timer: float = 4.0

#used to prevent instant explosion on floor explosion
#var able_to_explode_timer = .3
#var can_star_explode = false
var ignore_first_bounce_collision = false

@export var number_of_projectiles_in_explosion: int = 6
@export var projectile_scene: PackedScene
@export var projectile_stats: Resource

#bounce logic
@export var collision_ray: RayCast2D
var recalculate_ray_counter = 0
var recalculate_ray_frames = 6
@onready var raycast_length: float = collision_shape.shape.radius * 2

var freezing = false
var frozen = false
var unfreezing = false
var freeze_rate = 800.0
var unfreeze_rate = 800.0
var initial_frozen_timer = 6.0
var frozen_timer = initial_frozen_timer
var gravity_freeze_rate = 0.0

var infinite_bouncing_timer_initial = 6.0
var infinite_bouncing_timer = infinite_bouncing_timer_initial

@export var rotation_rate = 100

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
	frozen_timer = initial_frozen_timer
	unfreezing = false
	frozen = false
	freezing = true
	#print("freezing")
	#set_collision_mask_value(1,false)

func unfreeze():
	freezing = false
	frozen = false
	unfreezing = true

func _on_body_entered(body: Node2D) -> void:
	projectile_body_entered(body)
	if body.is_in_group("Player"):
		body.damage()
		projectile_explode()
	if body.is_in_group("Enemy"):
		#print("testdamage")
		body.damage(5)

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
			modulate = Color.DODGER_BLUE
			set_collision_mask_value(1,false)
			freezing = false
			frozen = true
			#print("frozen")
	if frozen:
		if frozen_timer > 0:
			frozen_timer -= delta
		elif frozen_timer <= 0:
			frozen_timer = initial_frozen_timer
			set_collision_mask_value(1,true)
			modulate = Color.WHITE
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
		if explosion_timer > 0 and !frozen:
			explosion_timer -= delta
		elif explosion_timer <= 0:
			if projectile_scene != null:
				star_explosion(number_of_projectiles_in_explosion,false)
			else:
				printerr("projectile not found")
			queue_free()
	#print("grav:" + str(current_gravity))
	#print("speed:" + str(speed))
	
	#if !can_star_explode and explodes_on_floor:
		#print(able_to_explode_timer)
		#if able_to_explode_timer > 0:
			#able_to_explode_timer -= delta
		#elif able_to_explode_timer <= 0:
			#can_star_explode = true
	if rotation_rate != 0:
		proj_sprite.rotation_degrees += rotation_rate * delta

func _physics_process(delta: float) -> void:
	if is_moving:
		projectile_move(delta)

#TODO: change velocity to direction, this is inconsistent
func projectile_move(delta: float):
	position += velocity.normalized() * speed * delta
	if affected_by_gravity:
		velocity.y += current_gravity * delta
	#print(velocity)
	if !frozen and recalculate_ray_counter % recalculate_ray_frames == 0:
		calculate_ray()
	#prevent bouncing forever
	if abs(velocity.x) < .1:
		velocity.x = 0
	if velocity.x == 0:
		if infinite_bouncing_timer > 0 and bounces_off_floor:
			infinite_bouncing_timer -= delta
		elif bounces_off_floor:
			queue_free()
	else:
		infinite_bouncing_timer = infinite_bouncing_timer_initial
	recalculate_ray_counter += 1

func projectile_explode():
	pass
	#print("explode projectile then queue free")

func projectile_body_entered(body: Node2D):
	#explodes on the floor
	if body.is_in_group("Floor"):
		#print("collided")
		if explodes_on_floor and !ignore_first_bounce_collision:
			is_moving = false
			if projectile_scene != null:
				star_explosion(number_of_projectiles_in_explosion,true)
			else:
				printerr("projectile not found")
			queue_free()
		elif ignore_first_bounce_collision:
			ignore_first_bounce_collision = false
		#bounces off floor
		#print(bounces_off_floor)
		#print(collision_ray.is_colliding())
		if bounces_off_floor and collision_ray.is_colliding() and collision_ray.get_collider().is_in_group("Floor"):
			#print("collide")
			var collision_normal = collision_ray.get_collision_normal()
			velocity = velocity.bounce(collision_normal)
			#TODO: note that off freeze it goes back to normal velocity
			#speed *= bounce_speed_dampen
			calculate_ray()

func star_explosion(number_of_projectiles: int,collide_on_floor: bool):
	var angle_inc = TAU / number_of_projectiles
	for i in number_of_projectiles:
		var angle = angle_inc * i
		var projectile = projectile_scene.instantiate() as Projectile
		initialize_spawning_projectile_from_resource(projectile)
		
	#todo - these become null because onready - this runs into a nullpointer on star-explosion
		if projectile.speed == null:
			projectile.speed = speed
		if projectile.gravity == null:
			projectile.gravity = gravity
		projectile.velocity = Vector2(cos(angle),sin(angle))
		projectile.position = position
		#offset spawn-in so the collisions work
		projectile.position -= (velocity * speed) * (4.0/120)
		projectile.ignore_first_bounce_collision = true
		if freezing:
			projectile.speed *= (speed/initial_speed)
			projectile.freeze()
		if collide_on_floor:
			if projectile.affected_by_hard_floor:
				set_collision_mask_value(2,false)
				collision_ray.set_collision_mask_value(2,false)
			if projectile.affected_by_soft_floor:
				set_collision_mask_value(3,false)
				collision_ray.set_collision_mask_value(3,false)
		get_parent().call_deferred("add_child",projectile)

func calculate_ray():
	collision_ray.target_position = velocity.normalized() * raycast_length

func send_back(from: Vector2,to: Vector2, send_back_speed: int):
	velocity = (to - from).normalized()
	affected_by_gravity = false
	speed = send_back_speed
	set_collision_layer_value(4,false)
	set_collision_layer_value(6,true)
	set_collision_mask_value(1,false)
	set_collision_mask_value(5,true)

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
	proj.projectile_stats = projectile_stats.projectile_stats
	proj.rotation_rate = projectile_stats.rotation_rate
	#todo - these become null because onready - this runs into a nullpointer on star-explosion
	proj.speed = projectile_stats.speed
	proj.gravity = projectile_stats.gravity

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		queue_free()
