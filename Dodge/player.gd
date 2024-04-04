extends Area2D

var speed = 400
var screen_size
var alive = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size   #取得螢幕尺寸
	
func _process(delta: float) -> void:
	# 角色是否活著
	if not alive:
		$AnimatedSprite2D.stop()
		return 
		
	var velocity = Vector2.ZERO   # 向量，玩家物體的速度
	
	#上下左右移動
	if(Input.is_action_pressed(&"move_down")):
		velocity.y += 1
	if(Input.is_action_pressed(&"move_up")):
		velocity.y -= 1	
	if(Input.is_action_pressed(&"move_right")):
		velocity.x += 1
	if(Input.is_action_pressed(&"move_left")):
		velocity.x -= 1
		
	if velocity != Vector2.ZERO:
		var direction = velocity.normalized()   #正規化的向量具有相同的方向，但長度為1
		
		position += direction * speed * delta
		position.x = clamp(position.x,0,screen_size.x)   #返回x範圍內的值
		position.y = clamp(position.y,0,screen_size.y)
		
		$AnimatedSprite2D.play()
	else :
		$AnimatedSprite2D.stop()
		
	if velocity.x != 0:
		#水平移動，walk，並且不垂直翻轉
		$AnimatedSprite2D.animation = &"walk"  
		get_node("AnimatedSprite2D").flip_v = false
		get_node("AnimatedSprite2D").flip_h = velocity.x < 0
	elif velocity.y != 0:
		#垂直移動，up，並且不水平翻轉
		$AnimatedSprite2D.animation = &"up"
		get_node("AnimatedSprite2D").flip_v = velocity.y > 0
		get_node("AnimatedSprite2D").flip_h = false
		
