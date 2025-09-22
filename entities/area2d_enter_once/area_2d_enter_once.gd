## Don't forget to call [code]super._ready()[/code] if the ready method is overridden
extends Area2D
class_name Area2DEnterOnce

static var _static_log = Logger.new("area2d_enter_once")

signal body_entered_once(body: Node2D)

var _bodies_entered: Dictionary

func _ready() -> void:
    _bodies_entered = {}
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
    
func _on_body_entered(body: Node2D):
    var id = body.get_instance_id()
    if _bodies_entered.has(id):
        return
    _bodies_entered.set(id, body)
    body_entered_once.emit(body)
    
func _on_body_exited(body: Node2D):
    _static_log.debug("body left: %s" % body)
    _bodies_entered.erase(body.get_instance_id())

func get_entered_bodies() -> Array[Node2D]:
    var out: Array[Node2D] = []
    for v: Node2D in _bodies_entered.values():
        out.append(v)
    return out
