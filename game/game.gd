extends Node2D

@onready var title_screen: TitleScreen = $TitleScreen
@onready var practice: Practice = $Practice

var _log = Logger.new("game")

func _ready() -> void:
    Events.player_created.connect(_on_player_created)
    title_screen.play_pressed.connect(_on_play_pressed)
    title_screen.practice_pressed.connect(_on_practice_pressed)

func _on_player_created(p: Player):
    add_child(p)

func _on_play_pressed():
    _log.info("play")

func _on_practice_pressed():
    _log.info("practice")
    title_screen.hide()
    practice.show()
