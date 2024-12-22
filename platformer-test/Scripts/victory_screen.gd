extends Control

@export var title_scene: PackedScene

func _ready():
	visible = false

func show_victory(time):
	var hours = int(time) / (3600)
	var minutes = (int(time) % 3600) / 60
	var seconds = (int(time) % 60)
	$PanelContainer/VBoxContainer/TimeLabel.text = "Time: " + str(hours) + ":" + str(minutes) + ":" + str(seconds)
	visible = true
	get_tree().paused = true

func _on_quit_pressed():
	get_tree().quit()

func _on_to_title_pressed() -> void:
	get_tree().change_scene_to_packed(title_scene)
