extends Resource
class_name RangeRatio

@export_range(0, 1, 0.05) var _min: float = 0
@export_range(0, 1, 0.05) var _max: float = 1

func _init(min_value: int = 0, max_value: int = 0) -> void:
    _min = min_value
    _max = max_value

func get_min() -> int:
    return _min
    
func get_max() -> int:
    return _max

func rand_lerp(a: int, b: int) -> int:
    return lerpf(a, b, randi_range(_min * 100, _max * 100) / 100)
