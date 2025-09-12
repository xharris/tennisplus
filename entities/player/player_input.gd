extends InputController
class_name PlayerInput

@export var config: PlayerInputConfig

func _unhandled_input(event: InputEvent) -> void:
    if not config:
        return
    
    if event.is_pressed() and not event.echo:
        config.emit_if_match(event, config.attack, attack)
        config.emit_if_match(event, config.ability, ability)
