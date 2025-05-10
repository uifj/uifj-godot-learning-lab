extends Node

## 通用状态基础接口。创建一个state interface，本身不做任何事情，但确保继承每个类有自己的方法。

# 忽略未使用的提示
@warning_ignore("unused_signal") 
signal finished(next_state_name: String) # 在stateMachine中自动化信号连接

# 状态的初始化的行为
func enter() -> void:
	pass

# 状态退出时的行为
func exit() -> void:
	pass
	
# 状态在每帧进行中的输入事件处理。 例如： 检查跳跃按钮，攻击等
func handle_input(_event: InputEvent) -> void:
	pass
	
# 物理帧更新。例如： 处理移动逻辑、状态的持续时间等
func update(_delta: float) -> void:
	pass

# 每个状态finished时携带的动画。 例如： 衔接连击动作
func _on_animation_finished(_anim_name: String) -> void:
	pass
