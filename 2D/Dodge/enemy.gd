extends RigidBody2D

#Gravity Scale: 重力
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 隨機挑選3種型態
	$AnimatedSprite2D.play()
	# 抓AnimatedSprite2D偵裡面的名稱
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	#[fly, swin, walk]
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#當節點物件超出遊戲視野範圍後，會從場景中移除並釋放相關資源
	queue_free()
