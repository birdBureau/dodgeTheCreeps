extends Area2D

signal enemy_hit

export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_Player_body_entered")
	$AnimatedSprite.connect("draw", self, "_on_AnimatedSprite_draw")
	hide()
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if velocity.length_squared() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walkHz"
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite.animation = "walkVt"
		$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide()
	emit_signal("enemy_hit")
	$CollisionShape2D.set_deferred("disabled", true)

func _on_AnimatedSprite_draw():
	$CollisionShape2D.set_deferred("disabled", false)