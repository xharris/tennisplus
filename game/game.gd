extends Node2D

@export var starting_level: LevelConfig

func _ready() -> void:
    if starting_level:
        LevelManager.enter(starting_level)
