## v = d / t
extends Node2D
class_name BallPhysics

@export var apply_to: Node2D
@export var speed_curve: Curve2D
var _log = Logger.new("ball_physics")
var _target: Node2D
var _position_curve: Curve2D
var _progress: float = 0
var _tween: Tween

func _physics_process(delta: float) -> void:
    if _tween and _progress < 1 and _position_curve:
        _tween.custom_step(delta)
        apply_to.global_position = _position_curve.sample(0, _progress)

func get_target() -> Node2D:
    return _target

func set_target(target: Node2D):
    _log.debug("set target: %s" % target)
    _target = target
    # create curve between ball and target
    var target_position = target.global_position
    var midpoint = (target_position + global_position) / 2
    _position_curve = Curve2D.new()
    _position_curve.add_point(global_position)
    _position_curve.add_point(target_position)
    # tween on path
    _tween = create_tween()
    _tween.set_trans(Tween.TRANS_LINEAR)
    _tween.set_ease(Tween.EASE_IN)
    _tween.tween_property(self, "_progress", 1, 1).from(0)
