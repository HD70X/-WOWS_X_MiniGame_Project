extends Node

# 玩家基础信息
var player_name: String = "Player"
var battles_played: int = 0

# 经济计算常量
const SCORE_TO_CREDITS: float = 0.2
const SCORE_TO_EXPERIENCE: float = 0.1

# 关卡进度
var unlocked_levels: Array = [1]  # 已解锁的关卡
var level_scores: Dictionary = {}  # 每关的最高分数
var level_stars: Dictionary = {}   # 每关的星级评价

# 游戏货币/资源
var credits: int = 1000 # 创建银币，并赋值初始单位1000枚
var experience: int = 0 # 玩家经验

# 解锁内容

# 当前装备配置(从 ShipConfig 迁移过来)
var current_ship: String = "res://Scenes/playerShip.tscn"
var equipped_weapons: Array = ["res://Scenes/PlayerWeapon/weapon_depth_charge_node_2d.tscn", "", ""]
var equipped_defense = null
var equipped_engine = null

# 游戏设置
var sound_volume: float = 1.0
var music_volume: float = 1.0
var language: String = "zh_CN"

# 保存文件路径
const SAVE_PATH = "user://wowsAVX_player_data.save"

func _ready():
	load_data()

# 战斗结算
func complete_battle(score: int):
	var earned_credits = int(score * SCORE_TO_CREDITS)
	credits += earned_credits
	var earned_experience = int(score * SCORE_TO_EXPERIENCE)
	experience += earned_experience
	battles_played += 1
	save_data()
	return {
		"credits": earned_credits,
		"experience": earned_experience
	}

# 储存数据
func save_data():
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		"credits": credits,
		"battles_played": battles_played,
		"experience": experience
	}
	save_file.store_var(data)

func load_data():
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = save_file.get_var()
	
	credits = data.get("credits", 1000)
	battles_played = data.get("battle_played", 0)
	experience = data.get("experience", 0)
