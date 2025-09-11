extends Node2D
class_name PaddleInput

signal swing_activated

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("paddle_swing"):
        swing_activated.emit()
