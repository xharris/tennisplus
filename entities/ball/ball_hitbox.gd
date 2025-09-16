extends AnimatableBody2D
class_name BallHitbox

signal accepted_visitor(v: Visitor)

var on_hit: Array[Visitor]

func _ready() -> void:
    add_to_group(Groups.BALL_HITBOX)

func accept(v: Visitor):
    accepted_visitor.emit(v)

func hit(body: Node2D):
    if body is HealthController:
        Visitor.visit_any(body, on_hit)
