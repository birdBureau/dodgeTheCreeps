extends Node2D

export (PackedScene) var Mob
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$HUD.connect("start_game", self, "new_game")
	$Player.connect("enemy_hit", self, "game_over")
	$StartTimer.connect("timeout", self, "_on_StartTimer_timeout")
	$ScoreTimer.connect("timeout", self, "_on_ScoreTimer_timeout")
	$MobTimer.connect("timeout", self, "_on_MobTimer_timeout")

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$BGMusic.stop()
	$DeathJingle.play()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.position = $StartPosition.position
	$Player.show()
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$BGMusic.play()

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	#Choose a random location on the MobPath
	$MobPath/MobSpawnLocation.set_offset(randi())
	var mob = Mob.instance()
	add_child(mob)
	# set the mob's direction perpendicular to the path's direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	#set the mob's position to a random location
	mob.position = $MobPath/MobSpawnLocation.position
	#add some randomness to the direction
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	#set the velocity
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	$HUD.connect("start_game", mob, "_on_start_game")