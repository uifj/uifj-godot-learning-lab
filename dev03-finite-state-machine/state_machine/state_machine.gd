
## 通用状态机基础接口。stateMachine interface，用于操作state
# ​​1.初始化管理​​(initializing)
	#处理状态机的启动配置
	#自动构建状态节点映射表
# ​​2.活性控制​​
	#通过 _active 属性开关状态机运行
	#激活时自动接管物理处理和输入事件
# ​​3.状态路由​​(change state)
	#将 _physics_process 和 _input 调用委托给当前活跃状态
# ​​4.堆栈式状态管理​​
	#支持状态压栈/弹栈操作
	#维护 states_stack 实现状态历史追踪
extends Node
## 生成状态机的base interface
# Base interface for a generic state machine.
# It handles initializing, setting the machine active or not
# delegating _physics_process, _input calls to the State nodes,
# and changing the current/active state.
# See the PlayerV2 scene for an example on how to use it.

signal state_changed(current_state: Node) # 状态转变的信号

# You should set a starting node from the inspector or on the node that inherits
# from this state machine interface. If you don't, the game will default to
# the first state in the state machine's children.
# 继承自这个stateMachine的scene需要再检查器中设置一个state
@export var start_state: NodePath
var states_map := {}  # 字典类型，状态名称到节点引用的映射

var states_stack := [] # 状态历史堆栈（实现状态回溯）
var current_state: Node = null # 当前活跃状态

# 控制状态机是否运行
var _active := false:
	set(value):
		_active = value
		set_active(value)

# 当节点进入 SceneTree 时调用（例如实例化时、场景改变时或者在脚本中调用 add_child() 后）
func _enter_tree() -> void:
	## 自动化信号连接，要求所有子节点都继承自 State 基类
	if start_state.is_empty():
		start_state = get_child(0).get_path()
	# 返回该节点的所有子节点到一个 Array 内，然后遍历。
	## 自动连接所有子状态的 finished 信号
	for child in get_children(): 
		var err: bool = child.finished.connect(_change_state)
		if err:
			printerr(err)
	initialize(start_state)


func initialize(initial_state: NodePath) -> void:
	_active = true
	states_stack.push_front(get_node(initial_state)) # 压入新状态
	current_state = states_stack[0]
	current_state.enter()


func set_active(value: bool) -> void:
	set_physics_process(value)
	set_process_input(value)
	if not _active:
		states_stack = []
		current_state = null

## 双更新模式分离（不太理解）
# 处理离散事件
func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)

# 处理连续更新
func _physics_process(delta: float) -> void:
	current_state.update(delta)


func _on_animation_finished(anim_name: String) -> void:
	if not _active:
		return

	current_state._on_animation_finished(anim_name)


func _change_state(state_name: String) -> void:
	print("StateMachine changeState: %s → %s",current_state.name, state_name)
	if not _active:
		return
	current_state.exit()

	if state_name == "previous":
		states_stack.pop_front() # 返回上一状态
	else:
		states_stack[0] = states_map[state_name]

	current_state = states_stack[0]
	state_changed.emit(current_state)

	if state_name != "previous":
		current_state.enter()
