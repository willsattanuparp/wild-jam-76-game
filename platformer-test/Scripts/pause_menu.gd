extends Control

@export var title_scene: PackedScene

func _ready():
	visible = false

func toggle_pause():
	if visible:
		visible = false
		get_tree().paused = false
	else:
		visible = true
		get_tree().paused = true

func _on_quit_pressed():
	get_tree().quit()


func _on_resume_pressed() -> void:
	#print("resume")
	toggle_pause()


func _on_to_title_pressed() -> void:
	get_tree().change_scene_to_packed(title_scene)
