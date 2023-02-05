extends Node2D
class_name Weapon

const PROJECTILE_SCENE: PackedScene = preload("res://actors/Projectile.tscn")

var data: ModuleData
var parent: Ship

var _clip: int
var _cooldown: float
var _reload: float
var _target: Ship

func _get_target() -> void:
  var _possible_targets: Array[Node]

  if parent.team == "enemies":
    _possible_targets = get_tree().get_nodes_in_group("player")
  else:
    _possible_targets = get_tree().get_nodes_in_group("enemies")

  for _node in _possible_targets:
    var _possible_target: Ship = _node

    if GDUtil.reference_safe(_possible_target) && _possible_target._hull >= 0.0 && _possible_target.global_position.distance_to(global_position) <= data.attack_range:
      _target = _possible_target
      break

func _fire() -> void:
  _clip -= data.burst
  _cooldown = data.cooldown_time
  if _clip <= 0:
    _reload = data.reload_time

  for _i in range(data.burst):
    var _new_projectile: Projectile = PROJECTILE_SCENE.instantiate()

    _new_projectile.global_position = global_position
    _new_projectile.data = data.projectile
    _new_projectile.team = parent.team
    _new_projectile.rotation = global_position.angle_to_point(_target.global_position)
    $"/root".add_child(_new_projectile)

func _process(delta: float) -> void:
  _cooldown = clampf(_cooldown - delta, 0.0, data.cooldown_time)

  if _clip <= 0:
    _reload = clampf(_reload - delta, 0.0, data.reload_time)

    if _reload <= 0.0:
      _clip = data.clip_size

  if _clip > 0 && _cooldown <= 0.0:
    if !GDUtil.reference_safe(_target):
      _get_target()

    if GDUtil.reference_safe(_target):
      _fire()

func _ready() -> void:
  _clip = data.clip_size
  _cooldown = 0.0
  _reload = 0.0
