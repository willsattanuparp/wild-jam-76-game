extends Resource

@export var initial_speed: int = 600
@export var velocity: Vector2 = Vector2.RIGHT
@export var gravity_effect: float = 5.0
@export var affected_by_gravity: bool = false
@export var bounces_off_floor: bool = false
@export var affected_by_hard_floor: bool = false
@export var affected_by_soft_floor: bool = false
#explosion logic
@export var explodes_on_floor: bool = false
#TODO explode from timer
@export var explode_from_timer: bool = false
@export var explosion_timer: float = 4.0

@export var number_of_projectiles_in_explosion: int = 6
@export var projectile_scene :PackedScene
@export var projectile_stats :Resource
