extends CharacterBody3D

const SPEED = 0.5

var player: Node3D

@onready var navAgent: NavigationAgent3D
@onready var visual: Node3D = $VisualNode
@onready var animationPlayer: AnimationPlayer = $VisualNode/AnimationPlayer

var direction: Vector3
var stopDistance: float = 2.2

func _ready():
	set_physics_process(false)
	call_deferred("actor_setup")
	
	player = get_tree().get_first_node_in_group("Player")
	navAgent = $NavigationAgent3D 
	
func actor_setup():
	NavigationServer3D.map_changed.connect(Callable(map_ready))

func map_ready(_rid): 
	set_physics_process(true)
	NavigationServer3D.map_changed.disconnect(Callable(map_ready))

func _physics_process(delta):
	navAgent.target_position = player.global_position
	
	direction = navAgent.get_next_path_position() - global_position
	direction.normalized()
	
	if navAgent.distance_to_target() < stopDistance:
		animationPlayer.play("NPC_01_IDEL")
		return
	
	velocity = velocity.lerp(direction * SPEED, delta)
	animationPlayer.play("NPC_01_WALK")
	
	if velocity.length() > 0.2:
		var lookDir = Vector2(velocity.z, velocity.x)
		visual.rotation.y = lookDir.angle()
	
	move_and_slide()
