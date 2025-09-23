extends Node
class_name AbilityController

signal accepted_visitor(v: Visitor)
signal attack_activated(ability: Ability)

var _abilities: Array[Ability]
@export var abilities: Array[Ability]:
    set(v):
        _abilities = []
        for a in v:
            add_ability(a)
    get:
        return _abilities

var _log = Logger.new("ability_controller")#, Logger.Level.DEBUG)
var meter: int = 0:
    set(v):
        meter = clampi(v, 0, 100)
var is_last_life: bool = false

func accept(v: Visitor):
    if v is AbilityControllerVisitor:
        v.visit_ability_controller(self)
    else:
        accepted_visitor.emit(v)

func set_log_prefix(prefix: String):
    _log.set_prefix(prefix)

func activate():
    for a in abilities:
        _log.debug("activate: %s" % [a.name])
        match a.type:
            Ability.ActivationType.Charge:
                if meter < 100:
                    _log.debug("meter not full: %d" % [meter])
                    continue
            Ability.ActivationType.LastLife:
                if not is_last_life:
                    _log.debug("not on last life")
                    continue
            Ability.ActivationType.Passive:
                _log.debug("skip activating passive")
                continue
        Visitor.visit_any(self, a.on_activate)

func increase_meter():
    meter += 10

func get_hit_by(element: Node2D):
    for a in abilities:
        Visitor.visit_any(self, a.on_hit_by_ball)
        Visitor.visit_any(element, a.on_hit_by_ball)

func hit(element: Node2D):
    for a in abilities:
        Visitor.visit_any(self, a.on_hit_ball)
        Visitor.visit_any(element, a.on_hit_ball)
    increase_meter()

func has_ability(ability_name: String) -> bool:
    for a in abilities:
        if a.name == ability_name:
            return true
    return false

func remove_ability_by_name(ability_name: String):
    abilities = abilities.filter(func(a: Ability):
        return a.name != ability_name)

func add_ability(a: Ability):
    _log.debug("add ability: %s" % [a.name])
    if has_ability(a.name):
        return _log.debug("already has ability")
    _abilities.append(a)
    if a.type == Ability.ActivationType.Passive:
        _log.debug("activate passive")
        Visitor.visit_any(self, a.on_activate)
