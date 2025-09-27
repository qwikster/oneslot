extends CharacterBody2D
@export var speed = 300
@onready var animated_sprite = $PlayerSprite
var last_dir = "north"

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	# Normalize the input vector to prevent faster diagonal movement
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
		update_animation(input_vector)
	else:
		velocity = Vector2.ZERO
		update_animation(input_vector) # Update to idle animation

	move_and_slide()

func update_animation(direction_vector):
	var animation_name = "idle_north"
	if direction_vector.length() > 0:
		# Determine the direction for animation
		if direction_vector.y < 0: # Up
			if direction_vector.x < 0:
				animation_name = "walk_northwest"
			elif direction_vector.x > 0:
				animation_name = "walk_northeast"
			else:
				animation_name = "walk_north"
		elif direction_vector.y > 0: # Down
			if direction_vector.x < 0:
				animation_name = "walk_southwest"
			elif direction_vector.x > 0:
				animation_name = "walk_southeast"
			else:
				animation_name = "walk_south"
		else: # Horizontal
			if direction_vector.x < 0:
				animation_name = "walk_west"
			elif direction_vector.x > 0:
				animation_name = "walk_east"
		last_dir = animation_name.trim_prefix("walk_")
	elif direction_vector.length() == 0:
		animation_name = "idle_" + str(last_dir)
	
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)
