class_name Bird
extends CharacterBody2D

signal score_updated(score: int)

const GRAVITY = 5
const JUMP = -100

var score := 0:
	set(new_score):
		score = new_score
		score_updated.emit(new_score)

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY
	if Input.is_action_just_pressed("fly"):
		velocity.y = JUMP
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		_die()

func _die() -> void:
	score = 0
	get_tree().reload_current_scene()
