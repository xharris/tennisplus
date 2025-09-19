extends PaddleVisitor
class_name PaddleVisitHitbox

## scene containing [code]PaddleHitbox[/code](es)
@export var scene: PackedScene

func visit_paddle(me: Paddle):
    var node = scene.instantiate()
    me.hitbox_controller.set_hitbox(node)
