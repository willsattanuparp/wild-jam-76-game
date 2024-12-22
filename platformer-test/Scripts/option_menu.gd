extends Control

@export var action_items: Array[String]

@onready var settings_grid_container = %SettingsGridContainer
@onready var main_menu_button = %MainMenuButton
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

func _ready() -> void:
	create_action_remap_items()

func create_action_remap_items():
	var previous_item = settings_grid_container.get_child(settings_grid_container.get_child_count() - 1)
	for index in range(action_items.size()):
		var action = action_items[index]
		var label = Label.new()
		label.text = action
		settings_grid_container.add_child(label)
		
		var button = RemapButton.new()
		button.action = action
		previous_item = button
		settings_grid_container.add_child(button)


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/UI/main_menu.tscn")


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID,linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)
