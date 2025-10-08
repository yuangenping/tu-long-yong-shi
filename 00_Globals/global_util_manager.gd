extends Node
## 工具类
## [br]
## 常用的一些通用方法

## 获取移动角色 向量缩放至单位长度的结果
func get_normalized_dir() -> Vector2:
	return Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down")
	).normalized()

## 方向索引
## [br]
## [param direction] 输入的方向向量
## [br]
## [param dir_count] 将圆周等分为多少份
## [br]
## [param offset_dir] 用于调整基准方向的偏移向量
func get_dir_index( direction : Vector2, # 输入的方向向量
	dir_count : int = 1, # 将圆周等分为多少份
	offset_dir : Vector2 = Vector2.ZERO # 用于调整基准方向的偏移向量
 ) -> int:
	return int( round( ( direction + offset_dir ).angle() / TAU * dir_count ) )
