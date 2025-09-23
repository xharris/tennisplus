extends Node2D
class_name Weapon

signal accepted_visitor
signal attack_started
## attack animation reached point where it should make contact with the ball
signal attack_window_entered
signal attack_window_exited

var _log = Logger.new("weapon")#, Logger.Level.DEBUG)
var _attack_window_entered = false
var _attack_timer: float = 0

## higher = faster
@export var attack_speed_scale: float = 1.0

func accept(v: Visitor):
    accepted_visitor.emit(v)

func _process(delta: float) -> void:
    if _attack_timer > 0:
        _attack_timer -= delta * attack_speed_scale
    else:
        _attack_timer = 0

func attack():
    if _attack_timer > 0:
        return _log.debug("attack timer not done")
    _attack_timer = Constants.ATTACK_TIMER
    attack_started.emit()

## NOTE do not call outside of animation player unless you know what you're doing
func attack_start():
    _log.debug("attack start")
    _attack_window_entered = true
    attack_window_entered.emit()

## NOTE do not call outside of animation player unless you know what you're doing
func attack_end():
    if not _attack_window_entered:
        return
    _log.debug("attack end")
    _attack_window_entered = false
    attack_window_exited.emit()

func is_attack_window_entered() -> bool:
    return _attack_window_entered

func hide_trails():
    for c: WeaponContactPoint in get_tree().get_nodes_in_group(Groups.WEAPON_CONTACT_POINT):
        if is_ancestor_of(c):
            c.hide()

func show_trails():
    for c: WeaponContactPoint in get_tree().get_nodes_in_group(Groups.WEAPON_CONTACT_POINT):
        if is_ancestor_of(c):
            c.show()
