extends Node3D

@onready var visual : Node3D = $VisualNode
@onready var pickpupVFX: GPUParticles3D = $VFXNode
#@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var rotateSpeed = 1
var coinValue = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	visual.rotate_y(rotateSpeed * delta)

	#if visual.visible == false && pickpupVFX.emitting == false:
		#queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group($"../Player"):
		queue_free()
		#pickpupVFX.emitting = true
		#visual.visible = false
		#animationPlayer.play("Collected")
		
		#body.AddCoin(coinValue)
		
