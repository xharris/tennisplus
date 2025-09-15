extends Area2D
class_name PaddleHitbox

signal accepted_visitor(v: Visitor)

@export var on_hit_ball: Array[Visitor]
## [code]true[/code]: will not trigger overlapping PaddleHitbox
@export var stop_propagation: bool = true
## On hit, hitboxes of the same [code]hitbox_group[/code] cannot
## hit the same body until it has exited the hitbox with
## [code]reset_group_on_body_exited[/code] set to [code]true[/code]
## [br][br]
## Empty string counts as a group
@export var hitbox_group: StringName
@export var reset_group_on_body_exit: bool
## will auto-hit any body that enters
@export var auto_hit: bool

var _log = Logger.new("paddle_hitbox")
var _entered_bodies: Dictionary
var disabled: bool = false

func accept(v: Visitor):
    accepted_visitor.emit(v)

func _ready() -> void:
    add_to_group(Groups.PADDLE_HITBOX)
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
    _log.info("entered: %s" % body)
    _entered_bodies[body] = body
    if auto_hit:
        _log.info("auto hit")
        hit(body)

func _on_body_exited(body: Node2D):
    _entered_bodies.erase(body)   

func get_entered_bodies() -> Array[Node2D]:
    var out: Array[Node2D]
    out.assign(_entered_bodies.values())
    return out

func hit(element: Node2D):
    Visitor.visit_any(element, on_hit_ball)
