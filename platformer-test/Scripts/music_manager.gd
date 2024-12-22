extends Node

var current_music = null
@onready var audio_player = $AudioStreamPlayer

func play_music(track_path: String):
	if current_music != track_path:
		current_music = track_path
		audio_player.stream = load(track_path)
		audio_player.play()

func stop_music():
	audio_player.stop()
	current_music = null

func fade_out_track(fade_time: float = 2.0):
	audio_player.volume_db = 0
	var tween = get_tree().create_tween()
	await tween.tween_property(audio_player,"volume_db",-80,fade_time)

func fade_in_track(fade_time: float = 2.0):
	audio_player.volume_db = -80
	var tween = get_tree().create_tween()
	await tween.tween_property(audio_player,"volume_db",0,fade_time)
