extends Resource
class_name ModuleData

@export_group("General")
@export var cost: float
@export var name: String
@export var power_drain: float
@export var size: GameConstants.SLOT_SIZES
@export var sprite: Texture2D
@export var type: GameConstants.SLOT_TYPES
@export_group("Util")
@export var armor: float
@export var battery: float
@export var power_generated: float
@export var shield_capacity: float
@export var shield_recharge: float
@export_group("Weapon")
@export var burst: int
@export var clip_size: int
@export var cooldown_time: float
@export var projectile: ProjectileData
@export var reload_time: float
