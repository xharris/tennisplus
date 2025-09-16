extends Node2D
class_name HealthController

signal damage_taken(amount: int)

@onready var area2d: Area2DEnterOnce = $Area2DEnterOnce
var _log = Logger.new("health_controller")

var _current: int = Constants.HEALTH_MAX:
    set(v):
        if v < _current and _invincible:
            return
        if v < _current:
            _log.info("damage taken: %d" % [_current - v])
            damage_taken.emit(_current - v)
        _current = v
var _max: int = Constants.HEALTH_MAX
var _invincible: bool = false

func accept(v: Visitor):
    if v is HealthVisitor:
        v.visit_health(self)

func set_log_prefix(prefix: String):
    _log.set_prefix(prefix)
