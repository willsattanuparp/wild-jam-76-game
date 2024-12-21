extends Control

@export var heart_bar: Sprite2D
@export var boss_bar: ProgressBar
@export var clock_bar: Node2D

func _on_player_ui_heart_damage() -> void:
	heart_bar.take_damage()

func _on_enemy_tree_update_hp_bar(value: Variant) -> void:
	boss_bar.value = value


func _on_player_update_clock_ui(value) -> void:
	clock_bar.update_clock_ui(value)
