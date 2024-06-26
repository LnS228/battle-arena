extends "res://characters/skin.gd"


@export var body_meshes: Array[MeshInstance3D]
@export var weapon: MeshInstance3D
@export var invisible: Material
@export var charged_weapon: Material
@export var ultimate: Material


func play_shoot() -> void:
    animationTree.set("parameters/PlayShoot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func play_charged_shot() -> void:
    animationTree.set("parameters/PlayChargeShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
    # weapon.material_override = charged_weapon
    # animationTree.animation_finished.connect(func(anim): weapon.material_override = null, CONNECT_ONE_SHOT)


func stop_charged_shot() -> void:
    animationTree.set("parameters/PlayChargeShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)


func play_throw() -> void:
    animationTree.set("parameters/PlayThrow/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func play_ultimate() -> void:
    # animationTree.set("parameters/UltimateTimeScale/scale", 0.8 / skill.execution.base_time)
    animationTree.set("parameters/PlayUltimate/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
    for mesh in body_meshes: mesh.material_override = ultimate
    # skill.execution.timeout.connect(func(): for mesh in body_meshes: mesh.material_override = null, \
    #    CONNECT_ONE_SHOT)


func play_dash() -> void:
    animationTree.set("parameters/PlayDash/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func play_invisibility() -> void:
    for mesh in body_meshes: mesh.material_override = invisible


func stop_invisibility() -> void:
    for mesh in body_meshes: mesh.material_override = null
