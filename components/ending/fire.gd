extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(randf()).timeout
	play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
