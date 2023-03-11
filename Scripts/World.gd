extends Node2D

onready var hud = $HUD
onready var obstacle_spawner = $ObstacleSpawner
onready var ground = $Ground
onready var menu_layer = $MenuLayer 
var score = 0 setget set_score
var high_score = 0
const SAVE_FILE_PATH = "user://save_data.save"

func _ready():
	obstacle_spawner.connect("obstacle_created",self,"_on_obstacle_created")
	load_highscore()

func player_score():
	self.score += 1
	
func new_game():
	self.score = 0
	obstacle_spawner.start()


func set_score(new_score):
	score = new_score
	hud.update_score(score)
	
func _on_obstacle_created(obs):
	obs.connect("score",self,"player_score")


func _on_DeathZone_body_entered(body):
	if body is Player:
		if body.has_method("die"):
			body.die()


func _on_Player_died():
	game_over()
	
func game_over():
	obstacle_spawner.stop()
	ground.get_node("AnimationPlayer").stop()
	get_tree().call_group("obstacle","set_physics_process()",false)
	if score > high_score:
		high_score = score
		save_highscore()
	menu_layer.init_game_over_menu(score,high_score)
	


func _on_MenuLayer_start_game():
	new_game()

func save_highscore():
	var save_data = File.new()
	save_data.open(SAVE_FILE_PATH,File.WRITE)
	save_data.store_var(high_score)
	save_data.close()

func load_highscore():
	var save_data = File.new()
	if save_data.file_exists(SAVE_FILE_PATH):
		save_data.open(SAVE_FILE_PATH,File.READ)
		high_score = save_data.get_var()
		save_data.close()
