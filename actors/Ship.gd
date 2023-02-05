extends Node2D
class_name Ship

const WEAPON_SCENE: PackedScene = preload("res://actors/Weapon.tscn")

@export var data: ShipData
@export var team: String

@onready var _hull_bar: ColorRect = %HullBar
@onready var _modules: Node2D = %Modules
@onready var _shield_bar: ColorRect = %ShieldBar
@onready var _sprite: Sprite2D = %Sprite2D

var _armor: float
var _battery: float
var _hull: float
var _move_direction: Vector2
var _move_speed: float
var _power_drain: float
var _shield: float
var _shield_capacity: float
var _shield_recharge_rate: float

func damage(damage_data: Dictionary) -> void:
  var _total_damage: float = damage_data.amount
  var _shield_damage: float = clampf(_total_damage, 0.0, _shield)
  
  _total_damage -= _shield_damage

  _shield -= _shield_damage
  _hull -= _total_damage

  _hull_bar.scale = Vector2(_hull / data.ship_class.hull, 1)
  _shield_bar.scale = Vector2(_shield / _shield_capacity, 1)

func move(direction: Vector2) -> void:
  _move_direction = direction.normalized()

func _initialize() -> void:
  _hull = data.ship_class.hull

func _update_modules() -> void:
  _move_speed = data.ship_class.thrust
  _battery = data.ship_class.power
  _power_drain = 0.0
  _shield_capacity = data.ship_class.shield_capacity
  _shield_recharge_rate = data.ship_class.shield_recharge

  for _module in data.modules:
    _power_drain += _module.power_drain

    match _module.type:
      GameConstants.SLOT_TYPES.UTIL:
        _move_speed += _module.thrust
        _shield_capacity += _module.shield_capacity
        _shield_recharge_rate += _module.shield_recharge
      GameConstants.SLOT_TYPES.ARMOR:
        _armor += _module.armor
      GameConstants.SLOT_TYPES.WEAPON:
        var _new_weapon: Weapon = WEAPON_SCENE.instantiate()
        
        _new_weapon.global_position = global_position
        _new_weapon.parent = self
        _new_weapon.data = _module
        _modules.add_child(_new_weapon)

func _physics_process(delta: float) -> void:
  if _move_direction.length() > 0:
    global_translate(_move_direction * _move_speed * delta)

  _move_direction = Vector2.ZERO

func _process(delta: float) -> void:
  _shield = clampf(_shield + (_shield_recharge_rate * delta), 0.0, _shield_capacity)
  _shield_bar.scale = Vector2(_shield / _shield_capacity, 1)

  if _hull <= 0.0:
    queue_free()

func _ready() -> void:
  _initialize() # TODO: Move this for loading runs in progress
  _update_modules()

  _sprite.texture = data.ship_class.sprite

  add_to_group(team)
