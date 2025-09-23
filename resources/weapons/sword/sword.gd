extends Weapon
class_name Sword

class Api:
    signal accepted_visitor(v: Visitor)
    
    signal meter_filled
    signal special_activated
    signal attack_landed
    
    func accept(v: Visitor):
        pass
        
var api: Api
