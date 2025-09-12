extends Node2D

@onready var title_screen: TitleScreen = $TitleScreen

func _ready() -> void:
    title_screen.play_pressed.connect(_on_play_pressed)
    
func _on_play_pressed():
    pass
