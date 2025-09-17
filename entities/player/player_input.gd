extends InputController
class_name PlayerInput

@export var config: PlayerInputConfig
## TODO
@export var device: int

func _unhandled_input(event: InputEvent) -> void:
    if not config:
        return
    
    if event.is_pressed() and not event.is_echo():
        if \
            config.emit_if_match(event, config.attack, attack) or\
            config.emit_if_match(event, config.ability, ability) or\
            config.emit_if_match(event, config.back, back):
                any_input.emit(event)
