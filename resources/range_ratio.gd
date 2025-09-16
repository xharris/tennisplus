extends Resource
class_name RangeRatio

static var _log = Logger.new("range_ratio")

@export_range(0, 1, 0.05) var _min: float = 0
@export_range(0, 1, 0.05) var _max: float = 1

func _init(min_value: int = 0, max_value: int = 0) -> void:
    _min = min_value
    _max = max_value

func get_min() -> int:
    return _min
    
func get_max() -> int:
    return _max

func rand_lerp(a: int, b: int) -> float:
    var weight: float = randi_range(_min * 100, _max * 100) / 100.0
    _log.debug("weight: [%f, %f] -> %f" % [_min, _max, weight])
    return lerpf(a, b, weight)
