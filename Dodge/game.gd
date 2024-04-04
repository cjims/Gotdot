extends Node2D

#加載寫好的場景
var enemy_scene = preload("res://enemy.tscn")
var score = 0
var high_score = 0

func _ready() -> void:
	#敵人出現的位置，隨機
	randomize()
	reset_player_position()
	$Audio.play()

#重製角色初始、重生位置
func reset_player_position():
	var pos = Vector2($Player.screen_size.x/2,$Player.screen_size.y/2)
	$Player.position = pos

#碰到敵人時觸發
func _on_player_body_entered(body: Node2D) -> void:
	
	if not $Player.alive:
		return		#return被用來終止 _on_player_body_entered的執行
	$Player.alive = false
	$Audio.stop()
	$Death.play()
	
	reset_player_position()
	$CanvasLayer/Start.visible = true
	$Timer.stop()
	$ScoreTimer.stop()
	
	$CanvasLayer/HighScore.visible = true
	if score > high_score:
		high_score = score
	$CanvasLayer/HighScore.text = "High Score : " + str(high_score)
	
	# 等待延遲後重新開始遊戲
	await get_tree().create_timer(2.6).timeout
	$Audio.play()
	
# 當計時器超時時調用的函數
func _on_timer_timeout() -> void:
	# 實例化敵人
	var enemy = enemy_scene.instantiate()
	var enemy_location = get_node("EnemyPath/EnemyLocation")
	
	# 隨機設置敵人的路徑進度
	enemy_location.progress = randi()
	
	# 計算敵人的移動方向
	var direction = enemy_location.rotation + PI/2		#PI = 180度
	enemy.position = enemy_location.position
	direction +=  randf_range(-PI/4,PI/4)		# 隨機調整敵人的旋轉方向
	enemy.rotation = direction
	
	# 設置敵人的速度
	var velocity = Vector2(randf_range(150.0,250.0),0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	
	# 將敵人添加到場景中
	$Enemys.add_child(enemy)
	
	# 調整計時器的等待時間以加快敵人生成速度
	$Timer.wait_time *= 0.99
	
func _on_start_pressed() -> void:
	$CanvasLayer/Start.visible = false
	
	for child in $Enemys.get_children():
		child.queue_free()
	
	$CanvasLayer/HighScore.visible = false	
	$CanvasLayer/Score.visible = true
	score = 0
	$CanvasLayer/Score.text = "0"
	$ScoreTimer.start()	
	
	$CanvasLayer/Dodge.visible = true
	await get_tree().create_timer(1).timeout
	$CanvasLayer/Dodge.visible = false
	
	$Player.alive = true
	$Timer.wait_time = 0.5
	$Timer.start()

#得分++
func _on_score_timer_timeout() -> void:
	score += 1
	$CanvasLayer/Score.text = str(score)
