extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 7
const SUPER_JUMP_VELOCITY = 25

var coinNumber: int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var character: Node3D = $VisualNode
@onready var neck := $Neck
@onready var camera := $"Neck/FPV Camera"
@onready var animationPlayer: AnimationPlayer = $VisualNode/AnimationPlayer
@onready var footStepVFX: GPUParticles3D = $VisualNode/VFX/Footstep_GPUParticles3D
@onready var collisionBox := $CharacterCollisionBox


func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"): 
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.002)
			camera.rotate_x(-event.relative.y * 0.002)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-50), deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Normal Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Handle Super Jump.		
	if Input.is_action_just_pressed("SuperJump") and is_on_floor():
		velocity.y = SUPER_JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = -direction.x * SPEED
		velocity.z = -direction.z * SPEED
		if is_on_floor():
			animationPlayer.play("LittleAdventurerAndie_Run")
			footStepVFX.emitting = true
		else:
			animationPlayer.play("LittleAdventurerAndie_Idel")
			footStepVFX.emitting = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		animationPlayer.play("LittleAdventurerAndie_Idel")
		footStepVFX.emitting = false
		
	if velocity.length() > 0.2:
		var lookDir = Vector2(velocity.z, velocity.x)
		character.rotation.y = lookDir.angle()

	move_and_slide()
	
func AddCoin(value: int):
	coinNumber += value
	print(coinNumber)
