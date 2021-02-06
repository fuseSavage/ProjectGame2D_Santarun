extends KinematicBody2D

export var speed = 350
export var gravity = 50
export var Jumspeed = 1000
export var Start_Speed = 300

var motion = Vector2()
var UP = Vector2(0, -1)
var score = 0
var Health = 4

var SNOWBALL = preload("res://snowball.tscn")
var is_dead = false

var is_attacking = false


func _ready():
	$sound_game.play()
	GameManager.Player = self
	set_physics_process(true)
	set_process(true)
	
	
func soundFX():
	$sound_coins.play()

func _process(delta):
	var LabelNode = get_parent().get_parent().get_node("mainscn/ScoreCounty/UI/Bese/RichTextLabel2")
	LabelNode.text = str(score)
	

func _physics_process(delta):
	motion.y += gravity
	
	if is_dead == false:
		
		if Input.is_action_pressed("ui_right"):
			if is_attacking == false:
				motion.x = speed
				$AnimatedSprite.flip_h = false
				$AnimatedSprite.play("run")
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
				if Input.is_action_pressed("ui_down"):
					$AnimatedSprite.play("slide")
		elif Input.is_action_pressed("ui_left"):
			if is_attacking == false:
				motion.x = -speed
				$AnimatedSprite.flip_h = true
				$AnimatedSprite.play("run")
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
				if Input.is_action_pressed("ui_down"):
					$AnimatedSprite.play("slide")
					
		elif Input.is_action_pressed("ui_down"):
			$AnimatedSprite.play("slide")
		else:
			motion.x = 0
			if is_attacking == false:
				$AnimatedSprite.play("idle")
				
		if is_on_floor():
			if Input.is_action_pressed("ui_up"):
				motion.y = lerp(motion.y, -Jumspeed, 0.99)
			
			
		if Input.is_action_just_released("ui_select") && is_attacking == false:
			is_attacking = true 
			$AnimatedSprite.play("shooter")
			print("funce input")
			var snowball = SNOWBALL.instance()
			if sign($Position2D.position.x) == 1:
				snowball.set_fireball_direction(1)
			else:
				snowball.set_fireball_direction(-1)
			get_parent().add_child(snowball)
			snowball.position = $Position2D.global_position
		motion = move_and_slide(motion,UP)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					dead()
				if "Underground" in get_slide_collision(i).collider.name:
					dead()
				if "door" in get_slide_collision(i).collider.name:
					get_tree().change_scene("Mainscn2.tscn")
				

func dead():
	is_dead = true
	motion = Vector2(0, 0)
	$AnimatedSprite.play("dying")
	#$CollisionShape2D.disabled = true
	$Timer.start()
	
	

func _on_Timer_timeout():
	is_dead = false
	Health -= 1
	print("dead",Health)

	if (Health == 3):
		var spritehealth_1 = get_parent().get_parent().get_node("mainscn/NodeHealth/aa/3")
		spritehealth_1.hide()
		$AnimatedSprite.play("dying")
	if (Health == 2):
		var spritehealth_2 = get_parent().get_parent().get_node("mainscn/NodeHealth/aa/2")
		spritehealth_2.hide()
		$AnimatedSprite.play("dying")

	if (Health == 1):
		get_tree().change_scene("GameOver.tscn")


func _on_AnimatedSprite_animation_finished():
	is_attacking = false