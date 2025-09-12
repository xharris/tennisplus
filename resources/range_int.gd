extends Resource
class_name RangeInt

@export var _min = 0
@export var _max = 0

func _init(min_value: int = 0, max_value: int = 0) -> void:
    _min = min_value
    _max = max_value

func get_min() -> int:
    return _min
    
func get_max() -> int:
    return _max

func rand() -> int:
    return randi_range(_min, _max)

func average() -> int:
    return (_min + _max) / 2
