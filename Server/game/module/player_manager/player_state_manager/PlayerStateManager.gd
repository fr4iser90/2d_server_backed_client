# PlayerStateManager ( Server) 
extends Node
@onready var player_idle_state_handler = $PlayerIdleStateHandler
@onready var player_moving_state_handler = $PlayerMovingStateHandler
@onready var player_attacking_state_handler = $PlayerAttackingStateHandler
@onready var player_casting_state_handler = $PlayerCastingStateHandler
@onready var player_swimming_state_handler = $PlayerSwimmingStateHandler
@onready var player_climbing_state_handler = $PlayerClimbingStateHandler
@onready var player_jumping_state_handler = $PlayerJumpingStateHandler
@onready var player_dashing_state_handler = $PlayerDashingStateHandler
@onready var player_dodging_state_handler = $PlayerDodgingStateHandler
@onready var player_stunned_state_handler = $PlayerStunnedStateHandler
@onready var player_dead_state_handler = $PlayerDeadStateHandler
@onready var player_interacting_state_handler = $PlayerInteractingStateHandler
@onready var player_blocking_state_handler = $PlayerBlockingStateHandler
@onready var player_riding_state_handler = $PlayerRidingStateHandler
@onready var player_stealth_state_handler = $PlayerStealthStateHandler
@onready var player_healing_state_handler = $PlayerHealingStateHandler
@onready var player_falling_state_handler = $PlayerFallingStateHandler
@onready var player_flying_state_handler = $PlayerFlyingStateHandler
@onready var player_knocked_down_state_handler = $PlayerKnockedDownStateHandler
@onready var player_climbing_ladder_state_handler = $PlayerClimbingLadderStateHandler
@onready var player_sliding_state_handler = $PlayerSlidingStateHandler
@onready var player_crouching_state_handler = $PlayerCrouchingStateHandler
@onready var player_trading_state_handler = $PlayerTradingStateHandler
@onready var player_using_item_state_handler = $PlayerUsingItemStateHandler
@onready var player_aiming_state_handler = $PlayerAimingStateHandler
@onready var player_respawning_state_handler = $PlayerRespawningStateHandler
@onready var player_mounted_state_handler = $PlayerMountedStateHandler
@onready var player_teleporting_state_handler = $PlayerTeleportingStateHandler
@onready var player_disarmed_state_handler = $PlayerDisarmedStateHandler
@onready var player_paralyzed_state_handler = $PlayerParalyzedStateHandler
@onready var player_knocking_back_state_handler = $PlayerKnockingBackStateHandler
@onready var player_debuffed_state_handler = $PlayerDebuffedStateHandler
@onready var player_buffed_state_handler = $PlayerBuffedStateHandler
@onready var player_in_combat_state_handler = $PlayerInCombatStateHandler
@onready var player_encumbered_state_handler = $PlayerEncumberedStateHandler
@onready var player_frozen_state_handler = $PlayerFrozenStateHandler

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
