extends Area2D



func _ready():
	pass

func _physics_process(delta):
	$AnimatedSprite.play("gold")



func _on_collect_body_entered(body):
	GameManager.Player.soundFX()
	queue_free()
	var player = get_parent().get_parent().get_node("scnPlayer")
	player.score += 10
