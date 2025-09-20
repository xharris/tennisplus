extends PaddleVisitor
class_name PaddleVisitHitbox

static var _log = Logger.new("visit_paddle_hitbox")

## scene containing [code]PaddleHitbox[/code](es)
@export var scene: PackedScene

func visit_paddle(me: Paddle):
    _log.debug("set: %s" % [scene.resource_path])
    var node = scene.instantiate()
    me.hitbox_controller.set_hitbox(node)
