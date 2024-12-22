extends Control

@export var options_scene: PackedScene
@export var tutorial_scene: PackedScene

func _on_play_pressed() -> void:
	pass

func _on_options_pressed() -> void:
	get_tree().change_scene_to_packed(options_scene)

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_tutorial_pressed() -> void:
	pass # Replace with function body.
