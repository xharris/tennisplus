extends Resource
class_name PlayerInputConfig

@export var attack: Array[InputEvent]
@export var ability: Array[InputEvent]
@export var swap: Array[InputEvent]
@export var back: Array[InputEvent]
@export var pause: Array[InputEvent]
@export var up: Array[InputEvent]
@export var down: Array[InputEvent]
@export var left: Array[InputEvent]
@export var right: Array[InputEvent]

func is_match(events: Array[InputEvent], event: InputEvent) -> bool:
    for e in events:
        if event.is_match(e):
            return true
    return false

func is_pressed(event: InputEvent, match_events: Array[InputEvent]) -> bool:
    return is_match(match_events, event) and event.is_pressed()

func emit_if_match(event: InputEvent, events: Array[InputEvent], sig: Signal):
    if is_match(events, event):
        sig.emit()
