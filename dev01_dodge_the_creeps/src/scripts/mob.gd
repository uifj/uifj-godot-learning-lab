extends RigidBody2D # 该node是实现物理仿真进行移动的 2D 物理体

func _ready() -> void:
	# 获取所有动画名
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random() # 随机选取一个动画
	$AnimatedSprite2D.play()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() #  “释放” 或删除帧末尾的节点，其所有子节点也将被删除
