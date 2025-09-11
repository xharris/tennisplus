extends Node2D
class_name Ball

@onready var physics: BallPhysics = $Physics
@onready var hitbox: BallHitbox = $Hitbox

func _ready() -> void:
    add_to_group(Groups.BALL)
    hitbox.accepted_visitor.connect(accept)

func accept(v: Visitor):
    if v is BallVisitor:
        v.visit_ball(self)
