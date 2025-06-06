class_name Bird
extends CharacterBody2D

signal score_updated(score: int)
signal final_score(score: int, best: int)

const GRAVITY = 5
const JUMP = -100

@onready var jump_audio: AudioStreamPlayer = $JumpAudio
@onready var score_audio: AudioStreamPlayer = $ScoreAudio
@onready var game_over_audio: AudioStreamPlayer = $GameOverAudio
@onready var dead_particles: CPUParticles2D = $CPUParticles2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var score := 0:
	set(new_score):
		score = new_score
		high_score = new_score
		score_updated.emit(new_score)
		if (new_score != 0 and score_audio.is_inside_tree()):
			score_audio.play()

static var high_score := 0:
	set(new_score):
		if new_score <= high_score: return
		high_score = new_score

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY
	if Input.is_action_just_pressed("fly"):
		velocity.y = JUMP
		jump_audio.pitch_scale = randf_range(0.75, 1.25)
		jump_audio.volume_db = randf_range(-6.0, -5.0)
		jump_audio.play()
		animation_player.stop()
		animation_player.play("fly")
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		_die()

func _die() -> void:
	final_score.emit(score, high_score)
	score = 0
	get_tree().paused = true
	$Sprite2D.hide()
	game_over_audio.play()
	dead_particles.show()
	dead_particles.emitting = true
