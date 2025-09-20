extends CharacterSpriteVisitor
class_name Palette

static var _log = Logger.new("palette")
static var SHADER: Shader = preload("res://addons/eye_dropper/eye_dropper.gdshader")

@export var name: StringName
@export var input: Texture2D
@export var output: Texture2D
@export var color: Color = Color.WHITE

func visit_character_sprite(me: CharacterSprite):
    _log.info("set palette: %s" % [name])
    me.hand_l_sprite.modulate = color
    me.hand_r_sprite.modulate = color
    me.sprites.material = get_final_material()

func get_final_material() -> ShaderMaterial:
    _log.error(not input or not output, "Palette textures missing.")

    var input_img := input.get_image()   # returns an Image
    var output_img := output.get_image()

    # If image data is compressed (common for imported PNGs), decompress it first.
    if input_img.is_compressed():
        input_img.decompress()
    if output_img.is_compressed():
        output_img.decompress()

    var in_colors: Array = []
    var out_colors: Array = []
    var seen := {}

    for y in range(input_img.get_height()):
        for x in range(input_img.get_width()):
            var c_in: Color = input_img.get_pixel(x, y)
            var c_out: Color = output_img.get_pixel(x, y)

            # Use a string key so we can detect duplicates
            var key = str(c_in.r) + "," + str(c_in.g) + "," + str(c_in.b) + "," + str(c_in.a)

            if not seen.has(key):
                seen[key] = true
                in_colors.append(c_in)
                out_colors.append(c_out)

    var mat = ShaderMaterial.new()
    mat.shader = SHADER
    mat.set_shader_parameter("input_palette_texture", null)
    mat.set_shader_parameter("output_palette_texture", null)
    mat.set_shader_parameter("palette_array_size", in_colors.size())
    mat.set_shader_parameter("input_palette_array", in_colors)
    mat.set_shader_parameter("output_palette_array", out_colors)

    _log.info("loaded palette: %d colors" % [in_colors.size()])
    _log.debug("\tinput %s" % [in_colors])
    _log.debug("\toutput %s" % [out_colors])
    return mat
