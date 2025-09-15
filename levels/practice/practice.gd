extends Node2D
class_name Practice

static var SCENE = preload("res://levels/practice/practice.tscn")
static var PRACTICE_DUMMY = preload("res://levels/practice/practice_dummy.tscn")

static func create() -> Practice:
    return SCENE.instantiate() as Practice

signal exit

@onready var player_manager: PlayerManager = $PlayerManager
var _log = Logger.new("practice")
@export var on_ball_created: Array[Visitor]

func _ready() -> void:
    visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed():
    if visible:
        # check that player1 exists
        var player1 = player_manager.get_player1()
        if _log.warn_if(not player1, "no player1 found"):
            exit.emit()
            return
        # create practice dummy
        var view = get_viewport_rect()
        var practice_dummy = PRACTICE_DUMMY.instantiate() as Node2D
        practice_dummy.add_to_group(Groups.PRACTICE_DUMMY)
        practice_dummy.global_position.x = view.get_center().x
        practice_dummy.global_position.y = view.position.y + (view.size.y / 4)
        add_child(practice_dummy)
        # spawn a ball
        var ball = Ball.create()
        ball.global_position = view.get_center()
        add_child(ball)
        for v in on_ball_created:
            ball.accept(v)
    else:
        for b: Ball in get_tree().get_nodes_in_group(Groups.BALL):
            b.queue_free()
