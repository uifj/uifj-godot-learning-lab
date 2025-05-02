extends CharacterBody2D

# 已经修改项目背景的环境颜色

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 200 # 同时修改项目设置中的重力系数

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# 在主循环的物理处理步骤中调用。物理处理的帧率与物理同步，即 delta 参数通常不变
func _physics_process(delta: float) -> void:
	## 水平移动代码
	# 首先获取用户输入, get_axis 是通过指定两个动作来获取轴的输入，一个是负的，一个是正的。
	var walk := WALK_FORCE * (Input.get_axis(&"ui_left",&"ui_right"))
	
	# 如果没有按下移动，降低移动速度
	if abs(walk) < WALK_FORCE * 0.2:
		# 当前速度向量，单位为像素每秒. move_toward使用从x向0移动
		velocity.x = move_toward(velocity.x,0,STOP_FORCE * delta)
	else:
		velocity.x += walk * delta
	# 限制水平移动的最大速度.s
	velocity.x = clamp(velocity.x,-WALK_MAX_SPEED,WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta
	# 根据 velocity 移动该物体。该物体如果与其他物体发生碰撞，则会沿着对方滑动
	move_and_slide()
	
	# 如果最近一次调用 move_and_slide() 时，该物体和地板发生了碰撞，则返回 true
	if is_on_floor() and Input.is_action_just_pressed(&"jump"):
		velocity.y = -JUMP_SPEED
