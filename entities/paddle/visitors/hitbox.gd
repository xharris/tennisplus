extends PaddleVisitor
class_name PaddleVisitHitbox

static var _log = Logger.new("visit_paddle_hitbox")#, Logger.Level.DEBUG)

## scene containing [code]PaddleHitbox[/code](es)
@export var scene: PackedScene

func visit_paddle_hitbox_controller(me: PaddleHitboxController):
    _log.debug("set: %s" % [scene.resource_path])
    var node = scene.instantiate()
    me.set_hitbox(node)
