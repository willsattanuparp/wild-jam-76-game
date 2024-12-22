class_name Level extends Node2D

@onready var special_scene : PackedScene = load("res://Assets/Scenes/freeze_splash.tscn")

@export var player: Player
@export var enemy: Enemy
@export var special_holder_node: Node2D
@export var projectile_holder_node: Node2D
@export var clock_holder_node: Node2D
@export var exit_area: Area2D
@export var clock_spawn_area: CollisionShape2D

@export var clock_scene: PackedScene

@export var pause_menu: CenterContainer

@onready var spawn_area = clock_spawn_area.shape.extents
@onready var origin = clock_spawn_area.global_position - spawn_area

var initial_clock_spawn_timer = 3.0
var clock_spawn_timer = initial_clock_spawn_timer

var time_in_level = 0.0
var is_playing = true
#var test_shake : PCamShake 
#
func _ready() -> void:
	player.special.connect(_on_player_special)
	player.game_over.connect(_on_game_over)
	enemy.victory.connect(_on_victory)
	#test_shake = $ProCam2D.get_addons()[0]
	#test_shake.shake()

func _on_victory():
	$UI/VictoryScreen.show_victory(time_in_level)

func _on_game_over() -> void:
	$UI/GameOverScreen.show_game_over()

func _on_player_special() -> void:
	var special = special_scene.instantiate()
	special.global_position = player.position
	special_holder_node.add_child(special)
	special.freeze_ripple(1)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		pause_menu.toggle_pause()
	if clock_spawn_timer > 0:
		clock_spawn_timer -= delta
	else:
		clock_spawn_timer = initial_clock_spawn_timer
		initialize_clock()
	if is_playing:
		time_in_level += delta

func initialize_clock():
	var clock = clock_scene.instantiate()
	clock.global_position = gen_random_pos()
	clock_holder_node.add_child(clock)

func _on_exit_area_area_exited(area: Area2D) -> void:
	area.queue_free()

func gen_random_pos():
	var x = randf_range(origin.x, spawn_area.x)
	var y = randf_range(origin.y, spawn_area.y)
	
	return Vector2(x, y)
