extends Area2D

var sink_rate = 150

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.fill_time()
		queue_free()

func _physics_process(delta: float) -> void:
	position.y += sink_rate * delta
