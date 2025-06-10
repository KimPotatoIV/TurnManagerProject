extends Node

##################################################
# 턴이 넘어갈 때의 지연 시간
const TURN_DELAY: float = 0.5

# 등록된 유닛과 우선순위를 담는 배열
var units: Array[Dictionary] = []
# 현재 턴을 진행 중인 유닛의 인덱스
var current_turn_index: int = 0
# 현재 턴이 진행 중인지 여부
var is_turn_active: bool = false

##################################################
func _ready() -> void:
	# 시그널 버스를 통해 "turn_ended" 신호를 받아 처리하는 함수를 연결
	SignalBus.connect("turn_ended", Callable(self, "_on_unit_turn_ended"))

##################################################
# 유닛을 턴 매니저에 등록하는 함수
func register_unit(unit_value: Node, priority_value: int) -> void:
	# 중복 등록 방지
	for unit in units:
		if unit["unit"] == unit_value:
			return
	
	# 유닛과 우선순위를 함께 등록
	units.append({ "unit": unit_value, "priority": priority_value })
	# priority 값을 기준으로 작은 숫자가 먼저 턴을 갖도록 정렬
	units.sort_custom(func(a, b): return a["priority"] < b["priority"])

##################################################
# 전투를 시작하며 첫 번째 턴을 진행하는 함수
func start_battle() -> void:
	current_turn_index = 0
	start_turn()

##################################################
# 전투 종료 처리하는 함수로 유닛 배열 초기화, 인덱스 리셋, 플래그 초기화
func end_battle() -> void:
	units.clear()
	current_turn_index = 0
	is_turn_active = false
	print("[TurnManager] The battle has ended, and the Turn Manager has been reset.")

##################################################
# 현재 턴 시작 함수
func start_turn() -> void:
	# 유닛이 하나도 등록되어 있지 않은 경우 턴 시작 불가
	if units.is_empty():
		print("[TurnManager] There are no registered units.")
		return
	
	# 턴 진행 중 상태로 설정
	is_turn_active = true
	# 현재 턴의 유닛 가져오기
	var current_unit: Node = units[current_turn_index]["unit"]
	print("[TurnManager] Start turn: " + current_unit.name)
	# 해당 유닛의 턴 시작 처리로 .start_turn()는 unit의 함수
	if current_unit.has_method("start_turn"):
		current_unit.start_turn()
	else:
		print("[TurnManager] Unit" + current_unit.name + "does not have a start_turn() method.")

##################################################
# 턴 종료 시 실행되는 함수
func _on_unit_turn_ended(unit_value: Node) -> void:
	# 턴 종료 시그널을 보낸 유닛이 현재 턴이 아닌 경우 return
	if not unit_value == units[current_turn_index]["unit"]:
		return
	
	# 현재 턴 종료 처리
	is_turn_active = false
	# 다음 유닛의 인덱스로 넘김
	current_turn_index = (current_turn_index + 1) % units.size()
	# TURN_DELAY 만큼 대기
	await get_tree().create_timer(TURN_DELAY).timeout
	# 다음 유닛의 턴 시작
	start_turn()
