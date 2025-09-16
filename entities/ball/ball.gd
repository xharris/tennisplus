extends Node2D
class_name Ball

static var SCENE = preload("res://entities/ball/ball.tscn")

@onready var physics: BallPhysics = $Physics
@onready var hitbox: BallHitbox = $Hitbox
@export var on_create: Array[Visitor]

func _ready() -> void:
    add_to_group(Groups.BALL)
    hitbox.accepted_visitor.connect(accept)
    
    Visitor.visit_any(self, on_create)

func accept(v: Visitor):
    if v is BallVisitor:
        v.visit_ball(self)

func destroy():
    var parent = get_parent()
    if parent:
        parent.remove_child(self)
    queue_free()
