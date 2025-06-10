# 유닛마다 사용하려는 노드가 다를 수 있으므로 본 노드를 상속에 사용하지 않음
# start_turn()와 end_turn() 사용 규칙을 지키면 됨
extends Node

##################################################
# 유닛의 턴이 시작될 때 호출
func start_turn() -> void:
	print("[BaseUnit] Turn started.")

##################################################
# 유닛의 턴이 끝났을 때 호출되며 SignalBus를 통해 'turn_ended' 신호를 자신(self)을 인자로 전달
func end_turn() -> void:
	SignalBus.emit_turn_ended(self)
