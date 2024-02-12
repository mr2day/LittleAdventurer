extends Node3D

@onready var coin: Node3D = $Coin
@onready var pickpupVFX: GPUParticles3D = $VFXNode
var rotateSpeed = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coin.rotate_y(rotateSpeed * delta)
	if coin.visible == false && pickpupVFX.emitting == false:
		queue_free()


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		pickpupVFX.emitting = true
		coin.visible = false
