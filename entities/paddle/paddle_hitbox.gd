extends Area2DEnterOnce
class_name PaddleHitbox

signal accepted_visitor(v: Visitor)

@export var on_hit_ball: Array[Visitor]
## [code]true[/code]: will not trigger overlapping PaddleHitbox
@export var stop_propagation: bool = true
## will auto-hit any body that enters
@export var auto_hit: bool

var disabled: bool = false

func accept(v: Visitor):
    accepted_visitor.emit(v)

func _ready() -> void:
    super._ready()
    _log.set_id("paddle_hitbox")
    add_to_group(Groups.PADDLE_HITBOX)
    body_entered_once.connect(_on_body_entered_once)

func _on_body_entered_once(body: Node2D):
    _log.debug("entered: %s" % body)
    if auto_hit:
        _log.debug("auto hit")
        hit(body)

func hit(element: Node2D):
    Visitor.visit_any(element, on_hit_ball)
