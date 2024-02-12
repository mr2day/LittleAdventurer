extends Node3D

@onready var coin : Node3D = $Coin
@onready var pickpupVFX: GPUParticles3D = $VFXNode
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

var rotateSpeed = 1
var coinValue = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coin.rotate_y(rotateSpeed * delta)

	if coin.visible == false && pickpupVFX.emitting == false:
		queue_free()

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		pickpupVFX.emitting = true
		animationPlayer.play("CoinPrize Collected")
		
		body.AddCoin(coinValue)
