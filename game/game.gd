extends Node2D

@onready var title_screen: TitleScreen = $TitleScreen
@onready var practice: Practice = $Practice

var _log = Logger.new("game")

func _ready() -> void:
    title_screen.play_pressed.connect(_on_play_pressed)
    title_screen.practice_pressed.connect(_show_practice)
    practice.exit.connect(_show_title_screen)

func _on_play_pressed():
    _log.info("play")

func _show_title_screen():
    _log.info("show title screen")
    practice.hide()
    title_screen.show()
    
func _show_practice():
    _log.info("show practice")
    title_screen.hide()
    practice.show()
