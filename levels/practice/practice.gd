extends Level
class_name Practice

static var PRACTICE_DUMMY = preload("res://levels/practice/practice_dummy.tscn")

func _ready() -> void:
    super._ready()
    # create practice dummy
    var view = get_viewport_rect()
    var practice_dummy = PRACTICE_DUMMY.instantiate() as Node2D
    practice_dummy.add_to_group(Groups.PRACTICE_DUMMY)
    practice_dummy.global_position.x = view.get_center().x
    practice_dummy.global_position.y = view.position.y + (view.size.y / 4)
    add_child(practice_dummy)
