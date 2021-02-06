extends Area2D

const SPEED = 500
var vilocity = Vector2()
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true
	

func _physics_process(delta):
	vilocity.x = SPEED * delta * direction
	translate(vilocity)
	$AnimatedSprite.play("snowball")
	

func _on_snowball_body_entered(body):
	if "Enemy" in body.name:
		body.dead()
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()



