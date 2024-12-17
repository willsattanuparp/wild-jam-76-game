class_name Projectile extends Area2D


@export var speed = 600
@export var velocity = Vector2.RIGHT


func freeze():
	pass

func _on_body_entered(body: Node2D) -> void:
	projectile_body_entered(body)
	if body.is_in_group("Player"):
		body.damage()
		projectile_explode()

func _process(delta: float) -> void:
	projectile_move(delta)

func projectile_move(delta: float):
	position += velocity.normalized() * speed * delta

func projectile_explode():
	print("explode projectile then queue free")

func projectile_body_entered(body: Node2D):
	pass
