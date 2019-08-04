extends RigidBody2D

export var min_speed = 150
export var max_speed = 250
var mob_types = ["fly", "swim", "walk"]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Visibility.connect("screen_exited", self, "_on_Visibility_screen_exited")
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	$AnimatedSprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Visibility_screen_exited():
	queue_free()

func _on_start_game():
	queue_free()