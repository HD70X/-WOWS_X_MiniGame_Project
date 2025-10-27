extends Node2D
class_name WeaponBase

# 定义武器基础属性
# 可以在编辑器中修改
@export var weapon_name: String = "Base Weapon"
@export var fire_cooldown: float = 0.1 # 武器释放间隔
@export var loading_cooldown: float = 0.3
@export var projector_num_max: int = 3
@export var projectile_scene: PackedScene # 弹药场景
@export var damage: int = 30

# 只能在代码中使用
var can_fire: bool = true
var projector_num: int
var is_loading: bool = false

func _ready():
	projector_num = projector_num_max

# 发射方法
func fire():
	# 如果投射无场景配置错误直接终止fire
	if not projectile_scene:
		return
	# 判定是否允许发射,CD或者装填中
	if not can_fire or projector_num == 0:
		return
	# 实例化弹药
	var projectile = projectile_scene.instantiate()
	# 设置弹药位置（相对于武器在舰船上的位置）
	projectile.global_position = global_position + Vector2(0, 30)
	# 将弹药添加到游戏场景
	get_tree().root.add_child(projectile)
	
	# 扣除一发弹药
	projector_num -= 1
	
	# 启动冷却
	start_cooldown()
	
	# 如果弹药不满，则尝试启动弹药装填
	if projector_num < projector_num_max and not is_loading:
		start_loading()

# 冷却管理
func start_cooldown():
	can_fire = false
	await get_tree().create_timer(fire_cooldown).timeout
	can_fire = true
	
# 弹药管理
func start_loading():
	is_loading = true
	
	# 循环装填弹药
	while projector_num < projector_num_max:
		# 等待装填时间
		await get_tree().create_timer(loading_cooldown).timeout
		# 装填完成，弹药总数加1
		projector_num += 1
	
	# 循环装填完成，弹药已满
	is_loading = false
