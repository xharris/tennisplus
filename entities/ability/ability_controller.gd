extends Node
class_name AbilityController

signal accepted_visitor(v: Visitor)
signal attack_activated(ability: Ability)

@export var abilities: Array[Ability]

var _log = Logger.new("ability_controller")#, Logger.Level.DEBUG)
var attack_cooldown: Dictionary
## ability is usable at 100
var ability_meter: int = 0
## higher = faster cooldown
var cooldown_speed_scale: float = 1.0

func accept(v: Visitor):
    accepted_visitor.emit(v)

func set_log_prefix(prefix: String):
    _log.set_prefix(prefix)

func _process(delta: float) -> void:
    for a in abilities:
        if attack_cooldown.has(a.name):
            var cd = attack_cooldown.get(a.name)
            cd -= delta * cooldown_speed_scale
            if cd <= 0:
                _log.debug("off cooldown: %s" % [a.name])
                attack_cooldown.erase(a.name)
            else:
                attack_cooldown.set(a.name, cd)

func do_passive():
    for a in abilities:
        Visitor.visit_any(self, a.passive)

func do_attack():
    for a in abilities:
        if attack_cooldown.has(a.name):
            continue
        _log.debug("set cooldown: %s (%d)" % [a.name, a.attack_cooldown])
        attack_cooldown.set(a.name, a.attack_cooldown)
        Visitor.visit_any(self, a.on_attack)
        attack_activated.emit(a)
        
func do_special():
    ## TODO uncomment
    #if ability_meter < 100:
        #return _log.debug("ability meter not filled")
    for a in abilities:
        Visitor.visit_any(self, a.on_special)
        
func do_ultimate():
    for a in abilities:
        Visitor.visit_any(self, a.on_ultimate)

func get_hit_by(element: Node2D):
    for a in abilities:
        Visitor.visit_any(self, a.on_hit_by_ball)
        Visitor.visit_any(element, a.on_hit_by_ball)

func hit(element: Node2D):
    for a in abilities:
        Visitor.visit_any(self, a.on_hit_ball)
        Visitor.visit_any(element, a.on_hit_ball)


func has_ability(ability_name: String) -> bool:
    for a: Ability in abilities:
        if a.name == ability_name:
            return true
    return false
    
func remove_ability_by_name(ability_name: String):
    abilities = abilities.filter(func(a: Ability):
        return a.name != ability_name)
