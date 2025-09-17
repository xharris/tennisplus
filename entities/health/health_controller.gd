extends Node2D
class_name HealthController

signal damage_taken(amount: int)
signal died

@onready var area2d: Area2DEnterOnce = $Area2DEnterOnce
var _log = Logger.new("health_controller")

var _current: int = Constants.HEALTH_MAX:
    set(v):
        var diff = v - _current
        if diff < 0 and _invincible:
            return
        if diff < 0:
            _log.info("damage taken: %d" % [_current - v])
            damage_taken.emit(_current - v)
        _current = v
        if _current <= 0 and diff < 0:
            _log.info("died")
            died.emit()
            
var _max: int = Constants.HEALTH_MAX
var _invincible: bool = false

func accept(v: Visitor):
    if v is HealthVisitor:
        v.visit_health(self)

func set_log_prefix(prefix: String):
    _log.set_prefix(prefix)

func is_alive() -> bool:
    return _current > 0
