extends Control

func _on_coin_collected(coins,lives):
	
	$Coins.text = str(coins)
	
	$Lives.text = str(lives)
	
