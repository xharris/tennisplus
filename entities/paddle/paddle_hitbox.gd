extends Area2D
class_name PaddleHitbox

var _log = Logger.new("paddle_hitbox")

func get_collisions() -> Array[Node2D]:
    return get_overlapping_bodies()
