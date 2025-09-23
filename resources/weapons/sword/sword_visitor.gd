extends WeaponVisitor
class_name SwordVisitor

func visit_weapon(me: Weapon):
    if me is Sword:
        visit_sword(me)

## TODO use this to increase ability duration?
func visit_sword(me: Sword):
    pass
