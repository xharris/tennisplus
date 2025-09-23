extends Resource
class_name Constants

const GLOBAL_LOG_LEVEL: Logger.Level = Logger.Level.DEBUG
const BALL_PHYSICS_TWEEN_DURATION = 3
static var BALL_SPEED_CURVE: Curve = preload("res://resources/curves/ball_speed_scale.tres")
static var BALL_PHYSICS_CONTROL_POINT_DISTANCE = RangeInt.new(60, 120)
static var BALL_PHYSICS_CONTROL_POINT_ANGLE_OFFSET = RangeInt.new(-30, 30)
static var PADDLE_HITBOX_INDICATOR_DISTANCE = 125
static var ATTACK_TIMER = 1.0
static var ABILITY_METER_MAX = 100
const HEALTH_MAX = 3
