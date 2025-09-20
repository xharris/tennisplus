extends InputController
class_name PlayerInput

var _log = Logger.new("player_input_controller")
@export var config: PlayerInputConfig
## TODO
@export var device: int

func on_input_event(event: InputEvent) -> void:
    if not config:
        return _log.warn("no config set")
    
    if event.is_pressed() and not event.is_echo():
        if \
            config.emit_if_match(event, config.attack, attack) or\
            config.emit_if_match(event, config.ability, ability) or\
            config.emit_if_match(event, config.back, back):
                any_input.emit(event)
