extends Node2D
class_name Weapon

signal attacked

var _log = Logger.new("weapon")

func attack():
    _log.debug("attack")
    attacked.emit()
