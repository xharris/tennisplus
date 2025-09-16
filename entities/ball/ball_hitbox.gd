extends AnimatableBody2D
class_name BallHitbox

signal accepted_visitor(v: Visitor)

var on_hit: Array[Visitor]

func _ready() -> void:
    add_to_group(Groups.BALL_HITBOX)

func accept(v: Visitor):
    accepted_visitor.emit(v)

func hit(element: Node):
    if element is HealthController:
        Visitor.visit_any(element, on_hit)
