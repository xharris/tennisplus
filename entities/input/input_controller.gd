extends Resource
class_name InputController

signal any_input(event: InputEvent)
signal attack
signal ability
signal back

## TODO use visitor pattern instead
func use_paddle_hitbox_controller(me: PaddleHitboxController):
    pass
    
func on_input_event(event: InputEvent) -> void:
    pass
