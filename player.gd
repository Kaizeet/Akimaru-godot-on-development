extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -350.0
const DEATH_Y_LIMIT = 700.0 # Batas y di mana karakter dianggap mati

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead = false # Status untuk mengecek apakah karakter mati

func _physics_process(delta):
	if is_dead:
		return # Jika mati, hentikan proses fisik

	# Penambahan gravitasi jika tidak di lantai
	if not is_on_floor():
		velocity.y += gravity * delta

	# Melompat jika di lantai
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if not $JumpSfx.is_playing():
			$JumpSfx.play()

	# Gerakan horizontal
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = direction == -1
	else:
		$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)

	# Animasi lompat
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")

	move_and_slide()

	# Deteksi kematian (jatuh melewati batas tertentu)
	if position.y > DEATH_Y_LIMIT:
		die()

func die():
	# Fungsi untuk menangani kematian karakter
	if is_dead:
		return # Hindari pemanggilan berulang

	is_dead = true
	velocity = Vector2.ZERO # Menghentikan gerakan
	$AnimatedSprite2D.play("death") # Mainkan animasi mati
	if not $DeathSfx.is_playing():
		$DeathSfx.play() # Mainkan efek suara mati jika ada
	
	# Jadwalkan respawn setelah 1 detik
	call_deferred("_async_spawn_character")

func _async_spawn_character():
	# Timer untuk menunda respawn
	await get_tree().create_timer(1.0).timeout
	respawn()

func respawn():
	# Fungsi untuk respawn karakter
	is_dead = false
	position = Vector2(400, 184) # Ganti dengan posisi respawn Anda
	velocity = Vector2.ZERO # Pastikan kecepatan direset
	$AnimatedSprite2D.play("idle") # Kembali ke animasi idle
	
	# Pastikan suara dihentikan jika masih bermain
	if $DeathSfx.is_playing():
		$DeathSfx.stop()
