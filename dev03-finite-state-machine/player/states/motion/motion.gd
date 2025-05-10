extends "res://state_machine/state.gd"

# 状态在每帧进行中的输入事件处理。 例如： 检查跳跃按钮，攻击等
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("simulate_damage"):
		finished.emit("stagger")

func get_input_direction() -> Vector2:
	return Vector2(
		Input.get_axis(&"move_left",&"move_right"),
		Input.get_axis(&"move_up",&"move_down")
	)

# 更新观看的方向
func update_look_direction(direction: Vector2) -> void:
	# owner引擎自带，是该节点的所有者。
	if direction and owner.look_direction != direction:
		owner.look_direction = direction
