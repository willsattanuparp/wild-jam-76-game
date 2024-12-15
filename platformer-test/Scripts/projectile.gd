class_name Projectile extends Area2D


@export var velocity = 600

func freeze():
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.damage()
		projectile_explode()

func _process(delta: float) -> void:
	projectile_move(delta)

func projectile_move(delta: float):
	position += Vector2.RIGHT.rotated(rotation) * velocity * delta

func projectile_explode():
	print("explode projectile then queue free")
