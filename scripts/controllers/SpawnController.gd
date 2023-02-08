extends Node2D

const ENEMY_SCENE: PackedScene = preload("res://actors/Enemy.tscn")

@export var max_spawn_distance: float
@export var min_spawn_distance: float
@export var spawn_interval: float

@onready var _player: Ship = get_tree().get_first_node_in_group("player")

var _time_to_spawn: float

func _process(delta: float) -> void:
  if GDUtil.reference_safe(_player):
    _time_to_spawn -= delta

    if _time_to_spawn <= 0:
      _time_to_spawn = spawn_interval

      var _new_enemy: Node2D = ENEMY_SCENE.instantiate()
      var _new_enemy_position: Vector2 = _player.global_position + (Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * randf_range(min_spawn_distance, max_spawn_distance))

      _new_enemy.global_position = _new_enemy_position
      $"/root".add_child(_new_enemy)
