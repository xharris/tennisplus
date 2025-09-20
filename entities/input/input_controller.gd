extends Resource
class_name InputController

signal any_input(event: InputEvent)
signal attack
signal ability
signal back

func use_paddle(paddle: Paddle):
    pass
    
func on_input_event(event: InputEvent) -> void:
    pass
