extends Control

var level_selecting: bool = false
var selected_level: int = 0

func _on_play_pressed() -> void:
	level_selecting = true
	$VBoxContainer.hide()
	$LevelSelect.show()


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/UI/option_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/UI/tutorial_menu.tscn")

func play_selected_level(level):
	match level:
		0:
			get_tree().change_scene_to_file("res://Assets/Scenes/Levels/deer_level.tscn")
		1:
			get_tree().change_scene_to_file("res://Assets/Scenes/Levels/santa_level.tscn")
		2:
			get_tree().change_scene_to_file("res://Assets/Scenes/Levels/tree_level.tscn")



func _on_left_pressed() -> void:
	if selected_level > 0:
		lower_level_idol(selected_level)
		selected_level -= 1
		raise_level_idol(selected_level)
	else:
		selected_level = 0



func _on_right_pressed() -> void:
	if selected_level < 2:
		lower_level_idol(selected_level)
		selected_level += 1
		raise_level_idol(selected_level)
	else:
		selected_level = 2

func raise_level_idol(level):
	pass

func lower_level_idol(level):
	pass

func _on_start_pressed() -> void:
	play_selected_level(selected_level)


func _on_back_pressed() -> void:
	level_selecting = false
	$VBoxContainer.show()
	$LevelSelect.hide()
