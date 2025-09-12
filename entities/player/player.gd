extends Node2D
class_name Player

static var SCENE = preload("res://entities/player/player.tscn")

@onready var paddle: Paddle = $Paddle

@onready var input: InputController

static func create() -> Player:
    var me = SCENE.instantiate() as Player
    return me
