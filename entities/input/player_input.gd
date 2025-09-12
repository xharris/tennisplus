extends InputController
class_name PlayerInput

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed(&"attack"):
        swing.emit()
