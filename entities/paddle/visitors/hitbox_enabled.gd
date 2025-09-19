extends PaddleVisitor
class_name PaddleHitboxEnabled

@export var enabled: bool = true

func visit_paddle(me: Paddle):
    me.hitbox_controller.enabled = enabled
