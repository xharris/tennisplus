extends Node2D
class_name PaddleHitboxController

var _log = Logger.new("paddle_hitbox_controller")

var _ignore_body: Dictionary

func swing():
    var hitboxes = _get_hitboxes()
    var is_hit = false
    for h in hitboxes:
        for b in h.get_entered_bodies():
            if _ignore_body.has(b):
                continue
            if b is BallHitbox:
                _log.debug("hit ball: %s" % h)
                is_hit = true
                for v in h.on_hit_ball:
                    b.accept(v)
            if is_hit:
                _ignore_body.set(b, true)
        # stop processing hitboxes
        if is_hit and h.stop_propagation:
            break
    # ignore body until it exits all of them
    for h in hitboxes:
        if not h.body_exited.is_connected(_on_hitbox_body_exited):
            h.body_exited.connect(_on_hitbox_body_exited)

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
    return hitboxes
