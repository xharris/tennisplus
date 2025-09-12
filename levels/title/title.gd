extends Node2D

@onready var play: Button = %Play
@onready var practice: Button = %Practice
@onready var player1: Player = $Player1

func _ready() -> void:
    var view_size = get_viewport_rect()
    player1.global_position.x = view_size.size.x / 2
    player1.global_position.y = view_size.position.y - 60
    
