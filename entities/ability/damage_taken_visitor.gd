extends Visitor
class_name DamageTaken

var damage_taken: int
var from_ability: Ability

func visit_health(_v: HealthController):
    pass
