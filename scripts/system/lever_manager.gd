extends Node
class_name LevelManager

@export var level_timer : Timer
@export var level_up_sfx : AudioStreamPlayer

var start_money_amount : int = 10
var current_money_amount : int = 10
var current_level : int = 1
var default_money_to_finish : int = 0
var _money_multiplier : int = 25
var goal_money : int

var highest_money : int = 0

signal money_increase(amount : int)
signal money_decrease(amount : int)

signal state_change(state : GameState)
signal next_level(level : int)

enum GameState {
	START,
	PAUSE,
	CONTINUE,
	OVER,
}

var game_state : GameState = GameState.START

func _enter_tree() -> void:
	Global.level_manager = self
	_update_goal_money()


func reduce_money(amount : int) -> void:
	current_money_amount -= amount
	if current_money_amount < 0:
		current_money_amount = 0
		switch_game_state(GameState.OVER)
		
	money_decrease.emit(amount)


func increase_money(amount : int) -> void:
	current_money_amount += amount
	if current_money_amount > highest_money:
		highest_money = current_money_amount

	money_increase.emit(amount)
	if current_money_amount > goal_money:
		_next_level()
	

func switch_game_state(state : GameState) -> void:
	game_state = state
	match state:
		GameState.START:
			level_timer.start(60)
		GameState.PAUSE:
			level_timer.paused = true
		GameState.CONTINUE:
			level_timer.paused = false
		GameState.OVER:
			level_timer.stop()
			
	state_change.emit(game_state)


func _on_timer_timeout() -> void:
	var money_to_finish = default_money_to_finish + (_money_multiplier * current_level)
	if(current_money_amount < money_to_finish):
		switch_game_state(GameState.OVER)
	else:
		_next_level()


func _next_level() -> void:
	level_timer.start(60)
	current_level += 1
	current_money_amount = 10
	_update_goal_money()
	level_up_sfx.play()
	next_level.emit(current_level)


func _update_goal_money() -> void:
	goal_money = default_money_to_finish + (_money_multiplier * current_level)
