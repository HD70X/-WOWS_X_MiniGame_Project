extends Area2D

var direction = 1
var time_elapsed = 0.0

var max_forward_speed = 220.0
var max_rising_speed = 350.0

func _ready():
	body_entered.connect(_on_body_entered)
	var submarine = get_parent().get_node_or_null("Submarine")
	if submarine:
		direction = submarine.direction
	rotation = PI/2 if direction == 1 else -PI/2

func _physics_process(delta):
	time_elapsed += delta
	
	# 使用平滑的时间曲线计算速度比例
	var forward_ratio = 1.0 - ease(time_elapsed / 2.0, -1.5)  # 2秒内从1降到0
	var rising_ratio = ease(time_elapsed / 2.0, 2.0)          # 2秒内从0升到1
	
	# 计算当前速度
	var forward_speed = max_forward_speed * forward_ratio
	var rising_speed = max_rising_speed * rising_ratio
	
	# 应用速度
	position.x += forward_speed * direction * delta
	position.y -= rising_speed * delta
	
	# 根据实际速度向量旋转
	var velocity = Vector2(forward_speed * direction, -rising_speed)
	if velocity.length() > 10:
		var target_angle = velocity.angle() + PI/2
		rotation = lerp_angle(rotation, target_angle, delta * 8)
	
	if position.y < 370:
		queue_free()

func _on_body_entered(body):
	if body.name == "Ship" or body.is_in_group("player"):
		body.take_damage(1)
		queue_free()
