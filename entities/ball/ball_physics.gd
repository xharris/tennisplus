## v = d / t
extends Node2D
class_name BallPhysics

signal target_set(target: Node2D)

var _log = Logger.new("ball_physics")#, Logger.Level.DEBUG)

@export var apply_to: Node2D
@export var speed_curve: Curve = Constants.BALL_SPEED_CURVE
var speed_scale: float = 0.5:
    set(v):
        speed_scale = clampf(v, 0, 1)
        var curve_speed_scale = speed_curve.sample(speed_scale)
        _log.debug("speed scale: %f -> %f" % [speed_scale, curve_speed_scale])
        if _tween:
            _tween.set_speed_scale(curve_speed_scale)
var curve_distance: RangeInt = Constants.BALL_PHYSICS_CONTROL_POINT_DISTANCE

var _target: Node2D
var _last_target: Node2D
var _position_curve: Curve2D
var _progress: float = 0
var _tween: Tween

var _debug_midpoint: Vector2
var _debug_control_point: Vector2

func _draw() -> void:
    draw_set_transform_matrix(global_transform.affine_inverse())
    draw_circle(_debug_midpoint, 10, Color.RED)
    draw_circle(_debug_control_point, 10, Color.GREEN)

func _process(delta: float) -> void:
    if _tween:
        queue_redraw()

func _physics_process(delta: float) -> void:
    if _position_curve and _target:
        # maintain ball target path
        _position_curve.set_point_position(1, _target.global_position)


func get_last_target() -> Node2D:
    return _last_target

func set_target(target: Node2D):
    if _tween and _tween.is_running():
        _on_tween_finished()
    _log.debug("set target: %s -> %s" % [_last_target, target])
    _target = target
    if not _target:
        return
    var target_position = target.global_position
    var midpoint = (target_position + global_position) / 2
    _debug_midpoint = midpoint
    # get tangent to direction
    var direction_to = global_position.direction_to(target_position)
    var angle_to = global_position.angle_to_point(target_position)
    var control_angle = angle_to - \
        deg_to_rad(90 + Constants.BALL_PHYSICS_CONTROL_POINT_ANGLE_OFFSET.rand())
    _log.debug("control_angle: %d" % rad_to_deg(control_angle))
    ## TODO add 180deg if control_point is offscreen?
    var control_point = midpoint + \
        (Vector2.from_angle(control_angle) * curve_distance.rand())
    _debug_control_point = control_point
    # create curve
    _position_curve = Curve2D.new()
    _position_curve.add_point(global_position)
    _position_curve.add_point(target_position)
    # create curve between ball and target
    _position_curve.set_point_out(0, control_point - global_position)
    _position_curve.set_point_in(1, control_point - target_position)
    # tween on path
    _tween = create_tween()
    _tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
    _tween.set_trans(Tween.TRANS_LINEAR)
    _tween.set_ease(Tween.EASE_OUT)
    _tween.tween_method(
        func(p):
            apply_to.global_position = _position_curve.sample(0, p),
        0.0, 1.0,
        Constants.BALL_PHYSICS_TWEEN_DURATION
    )
    _tween.finished.connect(_on_tween_finished)
    _last_target = target
    target_set.emit(target)

func _on_tween_finished():
    _log.debug("tween finished")
    _last_target = _target
    _target = null
