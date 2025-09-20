extends Node2D
class_name Weapon

## attack animation reached point where it should make contact with the ball
signal attack_window_entered
signal attack_window_exited

var _log = Logger.new("weapon")#, Logger.Level.DEBUG)
var _attack_window_entered = false

func attack_start():
    _log.debug("attack start")
    _attack_window_entered = true
    attack_window_entered.emit()

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
