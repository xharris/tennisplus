extends HealthVisitor
class_name HealthInvincible

@export var invincible: bool = true

func visit_health(me: HealthController):
    me._invincible = invincible
