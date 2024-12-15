extends Node2D

@export var freeze_explosion_texture: Sprite2D
@export var freeze_hitbox: Area2D

func freeze_ripple(time):
	var tween = get_tree().create_tween()
	var x_callback: Callable = func(value): freeze_explosion_texture.material.set_shader_parameter("x", value)
	tween.tween_method(x_callback,0.0,1.0,time)
	tween.parallel().tween_property(freeze_hitbox,"scale",Vector2(55,55),time)
	await tween.finished
	print("done")
	queue_free()



func _on_freeze_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Freezable"):
		area.freeze()
