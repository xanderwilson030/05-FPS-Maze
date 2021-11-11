extends KinematicBody

onready var Camera = $Pivot/Camera
onready var anim_player = get_node("/root/Game/Animate")
onready var raycast = $Pivot/Camera/RayCast
onready var player_score = get_node("/root/Game/EnemiesDestroyed")


onready var timer = get_node("/root/Game/Timer")
onready var label = get_node("/root/Game/Label")

onready var gun_shoot = $GunShoot

var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.002
var mouse_range = 1.2

const MAX_SPRINT_SPEED = 16
const SPRINT_ACCEL = 18
var is_sprinting = false
var health = 10

var velocity = Vector3()

var damage = 10
const MAX_CAM_SHAKE = 0.3

var enemies_destroyed = 0;


func _ready():
	timer.start(30)
	
func _process(delta):
	
	label.set_text("Time Remaining: " + str(timer.get_time_left()))
	
	if timer.get_time_left() <= 0:
		var _target = get_tree().change_scene("res://UI/Win.tscn")
		
	if health <= 0:
		var _scene = get_tree().change_scene("res://UI/MainMenu.tscn")



func fire():
	if Input.is_action_pressed("fire"):
		if not anim_player.is_playing():
			gun_shoot.play()
			Camera.translation = lerp(Camera.translation, 
			Vector3(rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 
			rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 0), 0.5)
			if raycast.is_colliding():
				var target = raycast.get_collider()
				if target.is_in_group("Enemy"):
					target.health -= damage;
					if target.health == 0:
						enemies_destroyed = enemies_destroyed + 1
						player_score.set_text("Enemies Destroyed: " + str(enemies_destroyed))
					
		anim_player.play("AssaultFire")
	else:
		Camera.translation = Vector3()
		anim_player.stop()
	

func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("forward"):
		input_dir += -Camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += Camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -Camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += Camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	
	if Input.is_action_pressed("movement_sprint"):
		is_sprinting = true
	else:
		is_sprinting = false

	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)

func _physics_process(delta):
	
	fire()
	
	velocity.y += gravity * delta
	var desired_velocity
	
	if is_sprinting:
		desired_velocity = get_input() * MAX_SPRINT_SPEED
	else:
		desired_velocity = get_input() * max_speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
