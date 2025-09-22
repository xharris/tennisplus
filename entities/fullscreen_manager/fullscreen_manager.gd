extends Node

func _input(event: InputEvent) -> void:
  if event.is_action_pressed("toggle_fullscreen"):
    if get_window().mode == Window.MODE_FULLSCREEN:
        get_window().mode = Window.MODE_WINDOWED
    else:
        get_window().mode = Window.MODE_FULLSCREEN
