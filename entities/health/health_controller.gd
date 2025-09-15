extends Node2D
class_name HealthController

signal body_entered(node: Node2D)

@onready var _area2d: Area2D = $Area2D

var _current: int = Constants.HEALTH_MAX:
    set(v):
        if v < _current and _invincible:
            return
        _current = v
var _max: int = Constants.HEALTH_MAX
var _bodies_entered: Dictionary
var _invincible: bool = false

func accept(v: Visitor):
    if v is HealthVisitor:
        v.visit_health(self)

func _ready() -> void:
    _area2d.body_entered.connect(_on_area2d_body_entered)
    _area2d.body_exited.connect(_on_area2d_body_exited)
    
func _on_area2d_body_entered(body: Node2D):
    if _bodies_entered.has(body):
        return
    _bodies_entered.set(body, true)
    body_entered.emit(body)

func _on_area2d_body_exited(body: Node2D):
    _bodies_entered.erase(body)
