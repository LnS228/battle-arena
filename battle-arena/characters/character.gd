extends CharacterBody3D


@export var player_id: int


@onready var stats: = get_node_or_null("Stats")
@onready var modifiers: = get_node_or_null("Modifiers")
@onready var skills: = get_node_or_null("Skills")
@onready var skin: = get_node_or_null("Skin")
@onready var input: = get_node_or_null("Input")
@onready var hit_box: HitBox = get_node_or_null("HitBox")
