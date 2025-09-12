extends AnimatableBody2D
class_name BallHitbox

signal accepted_visitor(v: Visitor)

var on_hit: Array[Visitor]

func _ready() -> void:
    add_to_group(Groups.BALL_HITBOX)

func accept(v: Visitor):
    accepted_visitor.emit(v)

func hit(body: Node2D):
    for v in on_hit:
        if body is HealthController:
            body.accept(v)
