extends Control

@export var heart_bar: Sprite2D


func _on_player_ui_heart_damage() -> void:
	heart_bar.take_damage()
