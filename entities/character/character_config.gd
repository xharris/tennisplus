extends Resource
class_name CharacterConfig

@export_placeholder("unknown") var name: String = "unknown"
@export var body_texture: Texture2D
@export var hand_texture: Texture2D
@export var palettes: Array[Palette]
@export var arm_length: int = 7
@export var arm_position: Vector2 = Vector2(8, 2)

func get_palette(index: int = 0) -> Palette:
    if palettes.is_empty():
        return null
    return palettes[clampi(index, 0, palettes.size())]
