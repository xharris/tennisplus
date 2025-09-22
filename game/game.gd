extends Node2D

@export var starting_level: LevelConfig

func _ready() -> void:
    LevelManager.accepted_visitor.connect(BallManager.accept)
    LevelManager.accepted_visitor.connect(PlayerManager.accept)
    if starting_level:
        LevelManager.enter(starting_level)
