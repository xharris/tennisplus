extends Resource
class_name PlayerInputConfig

@export var name: String
@export var attack: InputEvent
@export var ability: InputEvent
@export var swap: InputEvent
@export var back: InputEvent
@export var pause: InputEvent
@export var up: InputEvent
@export var down: InputEvent
@export var left: InputEvent
@export var right: InputEvent

func is_match(event: InputEvent, matches: InputEvent) -> bool:
    return event.is_match(matches)

func is_pressed(event: InputEvent, matches: InputEvent) -> bool:
    return event.is_pressed() and not event.is_echo() and is_match(event, matches)

func emit_if_match(event: InputEvent, matches: InputEvent, sig: Signal):
    if is_match(event, matches):
        sig.emit()
