extends Resource
class_name RangeInt

@export var min = 0
@export var max = 0

func _init(min_value: int = 0, max_value: int = 0) -> void:
    min = min_value
    max = max_value

func rand() -> int:
    return randi_range(min, max)
