# TileMap
extends Node

# EnvironmentalLayers
@onready var environmental_ground_layer = $EnvironmentalLayers/EnvironmentalGroundLayer
@onready var environmental_obstacle_layer = $EnvironmentalLayers/EnvironmentalObstacleLayer
@onready var environmental_decoration_layer = $EnvironmentalLayers/EnvironmentalDecorationLayer
@onready var environmental_terrain_layer = $EnvironmentalLayers/EnvironmentalTerrainLayer
@onready var environmental_water_layer = $EnvironmentalLayers/EnvironmentalWaterLayer
@onready var environmental_jumpable_layer = $EnvironmentalLayers/EnvironmentalJumpableLayer
@onready var environmental_climbable_layer = $EnvironmentalLayers/EnvironmentalClimbableLayer
@onready var environmental_crouchable_layer = $EnvironmentalLayers/EnvironmentalCrouchableLayer
@onready var environmental_walkable_platform_layer = $EnvironmentalLayers/EnvironmentalWalkablePlatformLayer


# InteractiveLayers
@onready var interactive_layers = $InteractiveLayers
@onready var interactive_player_spawn_layer = $InteractiveLayers/InteractivePlayerSpawnLayer
@onready var interactive_npc_spawn_layer = $InteractiveLayers/InteractiveNPCSpawnLayer
@onready var interactive_mob_spawn_layer = $InteractiveLayers/InteractiveMobSpawnLayer
@onready var interactive_teleport_layer = $InteractiveLayers/InteractiveTeleportLayer
@onready var interactive_hazard_layer = $InteractiveLayers/InteractiveHazardLayer
@onready var interactive_interactable_layer = $InteractiveLayers/InteractiveInteractableLayer
@onready var interactive_building_layer = $InteractiveLayers/InteractiveBuildingLayer


# NavigationLayers
@onready var navigation_layers = $NavigationLayers
@onready var navigation_no_fly_layer = $NavigationLayers/NavigationNoFlyLayer
@onready var navigation_blocking_layer = $NavigationLayers/NavigationBlockingLayer
@onready var navigation_pathfinding_hint_layer = $NavigationLayers/NavigationPathfindingHintLayer
@onready var navigation_no_build_layer = $NavigationLayers/NavigationNoBuildLayer


# Combat
@onready var combat_layers = $CombatLayers
@onready var combat_loot_zone_layer = $CombatLayers/CombatLootZoneLayer
@onready var combat_animation_trigger_layer = $CombatLayers/CombatAnimationTriggerLayer
@onready var combat_boss_room_layer = $CombatLayers/CombatBossRoomLayer
@onready var combat_danger_zone_layer = $CombatLayers/CombatDangerZoneLayer
@onready var combat_aggro_zone_layer = $CombatLayers/CombatAggroZoneLayer
@onready var combat_safe_zone_layer = $CombatLayers/CombatSafeZoneLayer

# Objective
@onready var objective_layers = $ObjectiveLayers
@onready var objective_zone_layer = $ObjectiveLayers/ObjectiveZoneLayer
@onready var objective_quest_layer = $ObjectiveLayers/ObjectiveQuestLayer


# VisualLayers
@onready var visual_layers = $VisualLayers
@onready var visual_resource_layer = $VisualLayers/VisualResourceLayer
@onready var visual_lighting_layer = $VisualLayers/VisualLightingLayer
@onready var visual_weather_layer = $VisualLayers/VisualWeatherLayer
@onready var visual_special_effect_layer = $VisualLayers/VisualSpecialEffectLayer


# AudioLayers
@onready var audio_layers = $AudioLayers
@onready var audio_sound_layer = $AudioLayers/AudioSoundLayer
