extends Node2D
class_name Trail

@onready var line2d: Line2D = $Line2D

@export var trail_width: float = 30
@export var trail_length: float = 30

func _ready() -> void:
    line2d.width = trail_width
    
func _process(_delta: float) -> void:
    #line2d.rotation = deg_to_rad(10)
    line2d.add_point(global_position)
    
    if line2d.get_point_count() > trail_length:
        line2d.remove_point(0)
