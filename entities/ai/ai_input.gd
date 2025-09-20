extends InputController
class_name AIInput

func use_paddle(paddle: Paddle):
    paddle.hitbox_controller.body_entered_once.connect(_on_body_entered_once)

func _on_body_entered_once(body: Node2D):
    if body is BallHitbox:
        attack.emit()
