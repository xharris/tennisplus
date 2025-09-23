extends Resource
class_name WeaponConfig

@export var name: StringName
@export var scene: PackedScene
## Be sure to add a 'Call Method' track for 
## [code]Sprites/ArmLOffset/ArmL/HandL/WeaponL/Sword[/code].
## that calls [code]attack()[/code] when the attack
## is supposed to land
@export var animations: AnimationLibrary
@export var can_reverse_animation: bool = false
@export var arm_length: int = 12

@export var abilities: Array[Ability]

func has_animations() -> bool:
    return animations and animations.get_animation_list_size() > 0
