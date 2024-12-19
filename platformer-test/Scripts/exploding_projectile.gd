extends Projectile

const GRAVITY = 5

@export var explode_from_timer: bool = false
@export var number_of_projectiles_in_explosion: int = 6
@export var projectile_scene :PackedScene
var is_moving = true

func projectile_move(delta: float):
	if is_moving:
		velocity.y += GRAVITY * delta
		super(delta)

func projectile_body_entered(body: Node2D):
	if body.is_in_group("Floor"):
		is_moving = false
		star_explosion(number_of_projectiles_in_explosion)
		queue_free()
		print("hit floor")

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
