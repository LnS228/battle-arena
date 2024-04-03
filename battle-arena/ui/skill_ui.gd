extends TextureRect


@onready var cooldown: Label = $Cooldown


var _skill

#func _ready() -> void:
    #scale -= Vector2(2.78, 2.78)

func register(skill) -> void:
    _skill = skill
    texture = Icons.get_icon(skill.root_name)


func _process(delta: float) -> void:
    if not _skill: return
    
    cooldown.visible = not is_zero_approx(_skill.cooldown)
    cooldown.text = "%1.2f" % _skill.cooldown
    
    #var enabled: bool = _skill.enabled and is_zero_approx(_skill.cooldown) and is_zero_approx(_skill.execution)
    #add_theme_color_override("font_color", Color.WHITE if enabled else Color.GRAY)

