extends Control

var level_selecting: bool = false
var selected_level: int = 0

func _ready() -> void:
	MusicManager.stop_music()
	MusicManager.play_music("res://Assets/Music/Wild Game Jam Menu Song.wav")
	get_tree().create_tween().tween_property($BlackTransition,"modulate:a",0,2.0)
	MusicManager.fade_in_track(2.0)

func _on_play_pressed() -> void:
	level_selecting = true
	get_tree().create_tween().tween_property($Figures/Deer/Deer,"global_position",$Figures/Deer/Top.global_position,.3)
	$VBoxContainer.hide()
	$LevelSelect.show()


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/UI/option_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/UI/tutorial_menu.tscn")

func play_selected_level(level):
	MusicManager.fade_out_track(4.0)
	get_tree().create_tween().tween_property($BlackTransition,"modulate:a",1,4.0)
	MusicManager.stop_music()
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
	var level_node = $Figures.get_child(level)
	var level_node_from = level_node.get_child(0)
	var level_node_to = level_node.get_child(1)
	get_tree().create_tween().tween_property(level_node_from,"global_position",level_node_to.global_position,.3)

func lower_level_idol(level):
	var level_node = $Figures.get_child(level)
	var level_node_from = level_node.get_child(0)
	var level_node_to = level_node.get_child(2)
	get_tree().create_tween().tween_property(level_node_from,"global_position",level_node_to.global_position,.3)

func _on_start_pressed() -> void:
	play_selected_level(selected_level)


func _on_back_pressed() -> void:
	level_selecting = false
	$VBoxContainer.show()
	$LevelSelect.hide()
