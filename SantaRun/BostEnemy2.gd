extends KinematicBody2D

const GRAVITY = 10
const SPEED = 180
const FLOOR = Vector2(0,-10)



var velocity = Vector2()

var direction = 1

var is_dead = false

var count = 0

func _ready():
	pass
	
	
	
func dead():
	count += 1
	if count > 5:
		is_dead = true
		var sound_snowball = $"sound_dead"
		sound_snowball.play()
		velocity = Vector2(0,0)
		$AnimatedSprite.play("dead")
		$CollisionShape2D.disabled = true
		$Timer.start()
	
func _physics_process(delta):
	if is_dead == false:
		velocity.x = SPEED * direction
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("walk")
		
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1 
		$RayCast2D.position.x *= -1
		
	
	if get_slide_count() > 0:
		for i in range (get_slide_count()):
			if "scnPlayer" in get_slide_collision(i).collider.name:
				get_slide_collision(i).collider.dead()
					
	
				
				

func _on_Timer_timeout():
	queue_free()
