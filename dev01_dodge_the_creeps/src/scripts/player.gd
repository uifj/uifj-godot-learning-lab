extends Area2D

signal hit

# 导出后，可以在检查器（Inspector）中修改speed的值
@export var speed = 400 #  How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready() -> void:
	screen_size = get_viewport_rect().size
	# test this gd, success
	#start(Vector2(100,100))

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	# 检测键盘按键是否按下
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		# normalized 将向量长度转换为单位长度
		# 同时按住两个方向键时，就是通过 勾三股四，取值为弦五）
		velocity = velocity.normalized() * speed 
		# $ is shorthand for get_node()，$ 是get_node()的缩写符号
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	# 限制移动空间，Vector2.ZERO代表（0，0）也就是左和上两边
	# scren_size是（480，720） 也就是右和下两边
	# 总结： x轴 在区间 (0,480)中， y轴 在区间（0,720）中。 
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# 按反方向键时，翻转角色（sprite）
	if velocity.x != 0:
		# 要确认动画名字，否则引擎无法合理选择动画
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

# connect signal hit，连接信号，Player的body_entered时发出信号
# body_entered 即 接收到物理撞击后
func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.碰撞后自动消失
	hit.emit() # 发出该信号。与该信号相连的所有 Callable 都将被触发。
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false
