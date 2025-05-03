## 该节点控制武器确保攻击的方向跟随主节点的方向
extends Marker2D

var z_index_start := 0

func _ready() -> void:
	owner.direction_changed.connect(_on_Parent_direction_changed)
	z_index_start = z_index


func _on_Parent_direction_changed(direction: Vector2) -> void:
	rotation = direction.angle()
	match direction:
		Vector2.UP:
			z_index = z_index_start - 1
		_:
			z_index = z_index_start
