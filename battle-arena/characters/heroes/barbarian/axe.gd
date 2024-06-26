extends "res://characters/skills/projectiles/projectile.gd"


@onready var animation: AnimationPlayer = $AnimationPlayer


var is_recalling: bool


func _ready() -> void:
    super._ready()
    collision_mask = owner.collision_mask | owner.collision_layer
    owner.on_throw_axe(self)
    animation.play("rotating", -1, 2.0)


func recall() -> void:
    is_recalling = true
    _is_travelling = false
    animation.play("rotating", -1, -2.0)


func _process(delta: float) -> void:
    super._process(delta)
    
    if not is_recalling: return
    var frame_distance: float = speed * delta # TODO: skill.projectile_speed * delta
    var direction: Vector3 = (owner.global_position - position).normalized()
    position += direction * frame_distance
    look_at(position + direction)


func _on_finish_travel() -> void:
    _is_travelling = false
    animation.play("floor_stuck")


func _on_area_entered(area: Area3D) -> void:
    if not is_multiplayer_authority(): return
    
    if _is_travelling or is_recalling:
        if area.collision_layer != collision_layer and area is HitBox:
            area.apply_damage.rpc(damage)
            owner.gain_energy.rpc(energy_gain)
    if is_recalling and area is HitBox and area.owner == owner:
        owner.on_pickup_axe.rpc()


func _on_obstacle_hit(obstacle: Node3D) -> void:
    if not _is_travelling: return
    if obstacle.has_node("HitBox"): return
    _is_travelling = false
    animation.play("obstacle_stuck")
