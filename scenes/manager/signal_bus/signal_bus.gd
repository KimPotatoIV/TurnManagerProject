extends Node

##################################################
# 'turn_ended' 신호를 선언하며 턴이 종료된 유닛(Node)을 인자로 전달
signal turn_ended(unit: Node)

##################################################
# 'turn_ended' 신호를 발생시키며 인자로 받은 unit을 신호와 함께 전달
func emit_turn_ended(unit: Node) -> void:
	emit_signal("turn_ended", unit)
