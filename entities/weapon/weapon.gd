extends Node2D
class_name Weapon

signal attacked

var _log = Logger.new("weapon")

func attack():
    _log.debug("attack")
    attacked.emit()

func hide_trails():
    for c: WeaponContactPoint in get_tree().get_nodes_in_group(Groups.WEAPON_CONTACT_POINT):
        if is_ancestor_of(c):
            c.hide()

func show_trails():
    for c: WeaponContactPoint in get_tree().get_nodes_in_group(Groups.WEAPON_CONTACT_POINT):
        if is_ancestor_of(c):
            c.show()
