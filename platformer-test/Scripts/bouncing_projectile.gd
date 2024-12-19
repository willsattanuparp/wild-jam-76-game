extends Projectile

const GRAVITY = 5

@export var affected_by_gravity = false
@export var collision_ray: RayCast2D
@export var raycast_length: float = 15

func _ready() -> void:
	calculate_ray()

func projectile_body_entered(body: Node2D):
	if body.is_in_group("Floor"):
		pass
	if collision_ray.is_colliding() and collision_ray.get_collider().is_in_group("Floor"):
		var collision_normal = collision_ray.get_collision_normal()
		velocity = velocity.bounce(collision_normal)
		calculate_ray()

func projectile_move(delta: float):
	super(delta)

func calculate_ray():
	collision_ray.target_position = velocity.normalized() * raycast_length
