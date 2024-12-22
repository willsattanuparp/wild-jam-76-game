extends Node2D

@export var freeze_explosion_texture: Sprite2D
@export var freeze_hitbox: Area2D

func freeze_ripple(time):
	var tween_texture = get_tree().create_tween()
	var tween_hitbox = get_tree().create_tween()
	var x_callback: Callable = func(value): freeze_explosion_texture.material.set_shader_parameter("x", value)
	tween_texture.tween_method(x_callback,0.0,1.0,time)
	tween_hitbox.tween_property(freeze_hitbox,"scale",Vector2(35,35),time * .7)
	if tween_hitbox.is_running():
		await tween_hitbox.finished
	freeze_hitbox.queue_free()
	if tween_texture.is_running():
		await tween_texture.finished
	#print("done")
	queue_free()



func _on_freeze_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Freezable"):
		area.freeze()
