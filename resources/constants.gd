extends Resource
class_name Constants

const GLOBAL_LOG_LEVEL: Logger.Level = Logger.Level.DEBUG
const BALL_PHYSICS_TWEEN_DURATION = 3
static var BALL_SPEED_CURVE: Curve = preload("res://resources/curves/ball_speed_scale.tres")
static var BALL_PHYSICS_CONTROL_POINT_DISTANCE = RangeInt.new(60, 120)
static var BALL_PHYSICS_CONTROL_POINT_ANGLE_OFFSET = RangeInt.new(-30, 30)
static var BALL_HITBOX_INDICATOR_DISTANCE = 125
static var ABILITY_BALL_HITS = RangeInt.new(1, 1)
const HEALTH_MAX = 3
