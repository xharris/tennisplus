extends Node2D
class_name PaddleHitboxController

signal accepted_visitor(v: Visitor)
signal attacked
signal hit(target: Node2D)

var _log = Logger.new("paddle_hitbox_controller")#, Logger.Level.DEBUG)
var cooldown: float = 1.0
var enabled: bool = false
var _cooldown_timer: float
var _ignore_body: Dictionary

func _process(delta: float) -> void:
    if _cooldown_timer > 0:
        _cooldown_timer -= delta
    else:
        _cooldown_timer = 0

func accept(v: Visitor):
    accepted_visitor.emit(v)

func set_log_prefix(prefix: String):
    _log.set_prefix(prefix)

func attack():
    if not enabled:
        return
    if _cooldown_timer > 0:
        return _log.info("attack on cooldown")
    _cooldown_timer = cooldown
    attacked.emit()
    var hitboxes = _get_hitboxes()
    var is_hit = false
    for h in hitboxes:
        for b in h.get_entered_bodies():
            if _ignore_body.has(b):
                continue
            if b is Node2D:
                _log.debug("hit: %s" % h)
                hit.emit(b)
                h.hit(b)
                is_hit = true
            if is_hit:
                _ignore_body.set(b, true)
        # stop processing hitboxes
        if is_hit and h.stop_propagation:
            break

func _on_hitbox_body_exited(body: Node2D):
    if _ignore_body.has(body):
        for h in _get_hitboxes():
            for b in h.get_entered_bodies():
                if b == body:
                    return
        _ignore_body.erase(body)

## get all PaddleHitboxes that are a child of this Paddle (recursive)
func _get_hitboxes() -> Array[PaddleHitbox]:
    var hitboxes: Array[PaddleHitbox]
    for h: PaddleHitbox in get_tree().get_nodes_in_group(Groups.PADDLE_HITBOX):
        if is_ancestor_of(h):
            hitboxes.append(h)
    # ignore body until it exits all of them
    for h in hitboxes:
        if not h.accepted_visitor.is_connected(accept):
            h.accepted_visitor.connect(accept)
        if not h.body_exited.is_connected(_on_hitbox_body_exited):
            h.body_exited.connect(_on_hitbox_body_exited)
    return hitboxes

func has_hitbox() -> bool:
    return not _get_hitboxes().is_empty()

func set_hitbox(node: Node2D):
    for c in get_children():
        remove_child(c)
        c.queue_free()
    add_child(node)
    _get_hitboxes()
