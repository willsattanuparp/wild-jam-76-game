extends Node2D

enum HEART_STATUSES {WHOLE = 1, HALF = 0, GONE = -1}
var current_status = HEART_STATUSES.WHOLE
@export var heart_sprite: Sprite2D
@export var half_heart_sprite: Sprite2D
@export var anim_player: AnimationPlayer

func update_heart(status):
	match status:
		HEART_STATUSES.WHOLE:
			heart_sprite.show()
			half_heart_sprite.hide()
		HEART_STATUSES.HALF:
			var anim_pos = anim_player.current_animation_position
			anim_player.play("half_heart")
			anim_player.seek(anim_pos)
			half_heart_sprite.show()
			heart_sprite.hide()
		HEART_STATUSES.GONE:
			heart_sprite.hide()
			half_heart_sprite.hide()
