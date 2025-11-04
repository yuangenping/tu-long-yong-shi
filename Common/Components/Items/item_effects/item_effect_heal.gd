class_name ItemEffectHeal extends ItemEffect

@export var heal_amount : int = 1
@export var audio : AudioStream


func use() -> void:
	PlayerManager.player.update_hp( heal_amount )
	# PlaySound
	if audio != null :
		PauseMenu.play_audio( audio )
