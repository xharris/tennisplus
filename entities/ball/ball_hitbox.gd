extends AnimatableBody2D
class_name BallHitbox

signal accepted_visitor(v: Visitor)

func _ready() -> void:
    add_to_group(Groups.BALL_HITBOX)

func accept(v: Visitor):
    accepted_visitor.emit(v)
