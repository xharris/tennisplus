extends Resource
class_name Constants

class RangeInt:
    var MIN = 0
    var MAX = 0
    func _init(min_value: int = 0, max_value: int = 0) -> void:
        MIN = min_value
        MAX = max_value
    func rand() -> int:
        return randi_range(MIN, MAX)

const BALL_PHYSICS_TWEEN_DURATION = 3
static var BALL_PHYSICS_CONTROL_POINT_DISTANCE = RangeInt.new(60, 120)
static var BALL_PHYSICS_CONTROL_POINT_ANGLE_OFFSET = RangeInt.new(-30, 30)
