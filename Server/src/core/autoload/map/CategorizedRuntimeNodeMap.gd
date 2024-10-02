var GlobalManager = {
	"DebugPrint": {
		"path_tree": "/root/GlobalManager/DebugPrint",
	},
	"GlobalConfig": {
		"path_tree": "/root/GlobalManager/GlobalConfig",
	},
	"NodeManager": {
		"path_tree": "/root/GlobalManager/NodeManager",
		"children": {
			"NodeMapManager": {
				"path_tree": "/root/GlobalManager/NodeManager/NodeMapManager",
				"children": {
					"GlobalManagerMap": {
						"path_tree": "/root/GlobalManager/NodeManager/NodeMapManager/GlobalManagerMap",
					},
					"CoreMap": {
						"path_tree": "/root/GlobalManager/NodeManager/NodeMapManager/CoreMap",
					},
					"UserMap": {
						"path_tree": "/root/GlobalManager/NodeManager/NodeMapManager/UserMap",
					},
					"GameMap": {
						"path_tree": "/root/GlobalManager/NodeManager/NodeMapManager/GameMap",
					},
					"NetworkDatabaseMap": {
						"path_tree": "/root/GlobalManager/NodeManager/NodeMapManager/NetworkDatabaseMap",
					},
					"NetworkGameMap": {
						"path_tree": "/root/GlobalManager/NodeManager/NodeMapManager/NetworkGameMap",
					},
				}
			},
			"NodeCacheManager": {
				"path_tree": "/root/GlobalManager/NodeManager/NodeCacheManager",
			},
			"NodeStateManager": {
				"path_tree": "/root/GlobalManager/NodeManager/NodeStateManager",
			},
			"NodeLifecycleManager": {
				"path_tree": "/root/GlobalManager/NodeManager/NodeLifecycleManager",
			},
			"NodeRetrievalManager": {
				"path_tree": "/root/GlobalManager/NodeManager/NodeRetrievalManager",
			},
			"NodeTemporaryManager": {
				"path_tree": "/root/GlobalManager/NodeManager/NodeTemporaryManager",
			},
			"NodeScanner": {
				"path_tree": "/root/GlobalManager/NodeManager/NodeScanner",
			},
			"NodeCategorizationManager": {
				"path_tree": "/root/GlobalManager/NodeManager/NodeCategorizationManager",
			},
		}
	},
	"SceneManager": {
		"path_tree": "/root/GlobalManager/SceneManager",
		"children": {
			"SceneCacheManager": {
				"path_tree": "/root/GlobalManager/SceneManager/SceneCacheManager",
			},
			"SceneLoadingManager": {
				"path_tree": "/root/GlobalManager/SceneManager/SceneLoadingManager",
			},
			"SceneOverlayManager": {
				"path_tree": "/root/GlobalManager/SceneManager/SceneOverlayManager",
			},
			"SceneTransitionManager": {
				"path_tree": "/root/GlobalManager/SceneManager/SceneTransitionManager",
			},
			"SceneStateManager": {
				"path_tree": "/root/GlobalManager/SceneManager/SceneStateManager",
			},
			"SceneScanner": {
				"path_tree": "/root/GlobalManager/SceneManager/SceneScanner",
			},
			"SceneNodeScanner": {
				"path_tree": "/root/GlobalManager/SceneManager/SceneNodeScanner",
			},
			"SceneSpawnPointScanner": {
				"path_tree": "/root/GlobalManager/SceneManager/SceneSpawnPointScanner",
			},
			"SceneTriggerScanner": {
				"path_tree": "/root/GlobalManager/SceneManager/SceneTriggerScanner",
			},
		}
	},
}

var ServerConsole = {
	"ServerConsoleContainer": {
		"path_tree": "/root/ServerConsole/ServerConsoleContainer",
		"children": {
			"PlaceHolderTop": {
				"path_tree": "/root/ServerConsole/ServerConsoleContainer/PlaceHolderTop",
				"children": {
					"PlaceHolderTop": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/PlaceHolderTop/PlaceHolderTop",
					},
				}
			},
			"TopStartServer": {
				"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopStartServer",
				"children": {
					"ServerLabel": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopStartServer/ServerLabel",
					},
					"ServerPresetList": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopStartServer/ServerPresetList",
					},
					"StartServerButton": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopStartServer/StartServerButton",
					},
					"StopServerButton": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopStartServer/StopServerButton",
					},
					"ServerPortLabel": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopStartServer/ServerPortLabel",
					},
					"ServerPortInput": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopStartServer/ServerPortInput",
					},
					"ServerAutoStartCheckButton": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopStartServer/ServerAutoStartCheckButton",
					},
					"UseDatabaseLabel": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopStartServer/UseDatabaseLabel",
					},
					"UseDatabaseTypeLabel": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopStartServer/UseDatabaseTypeLabel",
					},
				}
			},
			"TopBackend": {
				"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopBackend",
				"children": {
					"BackendIP": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopBackend/BackendIP",
					},
					"BackendIPInput": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopBackend/BackendIPInput",
					},
					"BackendPortLabel": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopBackend/BackendPortLabel",
					},
					"BackendPortInput": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopBackend/BackendPortInput",
					},
					"ServerValidationToken": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopBackend/ServerValidationToken",
					},
					"ServerValidationTokenInput": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopBackend/ServerValidationTokenInput",
					},
					"ConnectToBackend": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopBackend/ConnectToBackend",
					},
					"DisconnectFromBackend": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/TopBackend/DisconnectFromBackend",
					},
				}
			},
			"Mid": {
				"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid",
				"children": {
					"SideContainer": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/SideContainer",
						"children": {
							"PlayerListLabel": {
								"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/SideContainer/PlayerListLabel",
							},
							"PlayerContainer": {
								"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/SideContainer/PlayerContainer",
								"children": {
									"PlayerContainerPanel": {
										"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/SideContainer/PlayerContainer/PlayerContainerPanel",
										"children": {
											"PlayerListManager": {
												"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/SideContainer/PlayerContainer/PlayerContainerPanel/PlayerListManager",
											},
										}
									},
									"PlayerVisualMonitorPanel": {
										"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/SideContainer/PlayerContainer/PlayerVisualMonitorPanel",
									},
								}
							},
						}
					},
					"ControlContainer": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer",
						"children": {
							"ServerControlPanelLabel": {
								"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanelLabel",
							},
							"ServerControlPanel": {
								"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel",
								"children": {
									"ServerControlGridContainer": {
										"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer",
										"children": {
											"NetworkContainer": {
												"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/NetworkContainer",
												"children": {
													"Network": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/NetworkContainer/Network",
													},
												}
											},
											"PlayerControlsButton": {
												"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/PlayerControlsButton",
												"children": {
													"Player": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/PlayerControlsButton/Player",
													},
													"Kick": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/PlayerControlsButton/Kick",
													},
													"Ban": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/PlayerControlsButton/Ban",
													},
													"Watch": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/PlayerControlsButton/Watch",
													},
												}
											},
											"Container3": {
												"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/Container3",
												"children": {
													"Label": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/Container3/Label",
													},
													"Button": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/Container3/Button",
													},
													"Button2": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/Container3/Button2",
													},
													"Button3": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/Container3/Button3",
													},
													"Button4": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/Container3/Button4",
													},
													"Button5": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/Container3/Button5",
													},
													"Button6": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/Container3/Button6",
													},
												}
											},
											"Container4": {
												"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/Container4",
												"children": {
													"Label": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/Container4/Label",
													},
													"FeaturesList": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/ServerControlPanel/ServerControlGridContainer/Container4/FeaturesList",
													},
												}
											},
										}
									},
								}
							},
							"BackendButtonPanelLabel": {
								"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanelLabel",
							},
							"BackendButtonPanel": {
								"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel",
								"children": {
									"GridContainer": {
										"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer",
										"children": {
											"Container1": {
												"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/Container1",
												"children": {
													"Label": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/Container1/Label",
													},
												}
											},
											"LevelControlPanel": {
												"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/LevelControlPanel",
												"children": {
													"LevelControlPanel": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/LevelControlPanel/LevelControlPanel",
													},
													"GenerateButton": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/LevelControlPanel/GenerateButton",
													},
													"ViewLevelButton": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/LevelControlPanel/ViewLevelButton",
													},
													"Button3": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/LevelControlPanel/Button3",
													},
													"Button4": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/LevelControlPanel/Button4",
													},
													"Button5": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/LevelControlPanel/Button5",
													},
													"Button6": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/LevelControlPanel/Button6",
													},
												}
											},
											"Container3": {
												"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/Container3",
												"children": {
													"Label": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/Container3/Label",
													},
													"FeaturesList": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/Container3/FeaturesList",
													},
												}
											},
											"Container4": {
												"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/Container4",
												"children": {
													"Label": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/Container4/Label",
													},
													"FeaturesList": {
														"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ControlContainer/BackendButtonPanel/GridContainer/Container4/FeaturesList",
													},
												}
											},
										}
									},
								}
							},
						}
					},
					"ConsoleContainer": {
						"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ConsoleContainer",
						"children": {
							"ServerClientPanelLabel": {
								"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ConsoleContainer/ServerClientPanelLabel",
							},
							"ServerClientPanel": {
								"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ConsoleContainer/ServerClientPanel",
								"children": {
									"ServerLog": {
										"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ConsoleContainer/ServerClientPanel/ServerLog",
									},
								}
							},
							"ServerBackendPanelLabel": {
								"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ConsoleContainer/ServerBackendPanelLabel",
							},
							"ServerBackendPanel": {
								"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ConsoleContainer/ServerBackendPanel",
								"children": {
									"ServerBackendLog": {
										"path_tree": "/root/ServerConsole/ServerConsoleContainer/Mid/ConsoleContainer/ServerBackendPanel/ServerBackendLog",
									},
								}
							},
						}
					},
				}
			},
			"Bottom": {
				"path_tree": "/root/ServerConsole/ServerConsoleContainer/Bottom",
			},
		}
	},
	"Handler": {
		"path_tree": "/root/ServerConsole/Handler",
		"children": {
			"ServerConsoleLifeCycleHandler": {
				"path_tree": "/root/ServerConsole/Handler/ServerConsoleLifeCycleHandler",
			},
			"ServerConsolePresetHandler": {
				"path_tree": "/root/ServerConsole/Handler/ServerConsolePresetHandler",
			},
			"ServerConsoleSettingsHandler": {
				"path_tree": "/root/ServerConsole/Handler/ServerConsoleSettingsHandler",
			},
			"ServerConsoleUILoadHandler": {
				"path_tree": "/root/ServerConsole/Handler/ServerConsoleUILoadHandler",
			},
		}
	},
	"@Timer@9": {
		"path_tree": "/root/ServerConsole/@Timer@9",
	},
}

var User = {
	"UserSessionModule": {
		"path_tree": "/root/User/UserSessionModule",
		"children": {
			"Manager": {
				"path_tree": "/root/User/UserSessionModule/Manager",
				"children": {
					"UserSessionManager": {
						"path_tree": "/root/User/UserSessionModule/Manager/UserSessionManager",
						"children": {
							"Handler": {
								"path_tree": "/root/User/UserSessionModule/Manager/UserSessionManager/Handler",
								"children": {
									"SessionLockHandler": {
										"path_tree": "/root/User/UserSessionModule/Manager/UserSessionManager/Handler/SessionLockHandler",
									},
									"TimeoutHandler": {
										"path_tree": "/root/User/UserSessionModule/Manager/UserSessionManager/Handler/TimeoutHandler",
									},
									"SessionLockTypeHandler": {
										"path_tree": "/root/User/UserSessionModule/Manager/UserSessionManager/Handler/SessionLockTypeHandler",
									},
								}
							},
						}
					},
				}
			},
			"Handler": {
				"path_tree": "/root/User/UserSessionModule/Handler",
			},
		}
	},
}

var Game = {
	"GamePlayerModule": {
		"path_tree": "/root/Game/GamePlayerModule",
		"children": {
			"Manager": {
				"path_tree": "/root/Game/GamePlayerModule/Manager",
				"children": {
					"PlayerManager": {
						"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerManager",
						"children": {
							"Handler": {
								"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerManager/Handler",
								"children": {
									"PlayerSpawnHandler": {
										"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerManager/Handler/PlayerSpawnHandler",
									},
								}
							},
						}
					},
					"PlayerMovementManager": {
						"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager",
						"children": {
							"Handler": {
								"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementManager/Handler",
							},
						}
					},
					"PlayerMovementData": {
						"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementData",
						"children": {
							"Handler": {
								"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerMovementData/Handler",
							},
						}
					},
					"PlayerVisualMonitor": {
						"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerVisualMonitor",
						"children": {
							"Handler": {
								"path_tree": "/root/Game/GamePlayerModule/Manager/PlayerVisualMonitor/Handler",
							},
						}
					},
					"CharacterManager": {
						"path_tree": "/root/Game/GamePlayerModule/Manager/CharacterManager",
						"children": {
							"Handler": {
								"path_tree": "/root/Game/GamePlayerModule/Manager/CharacterManager/Handler",
							},
						}
					},
				}
			},
			"Handler": {
				"path_tree": "/root/Game/GamePlayerModule/Handler",
			},
		}
	},
	"GameWorldModule": {
		"path_tree": "/root/Game/GameWorldModule",
		"children": {
			"Manager": {
				"path_tree": "/root/Game/GameWorldModule/Manager",
				"children": {
					"InstanceManager": {
						"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager",
						"children": {
							"Handler": {
								"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler",
								"children": {
									"InstanceLifecycleHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceLifecycleHandler",
									},
									"InstanceSceneManager": {
										"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceSceneManager",
									},
									"InstanceCreationHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceCreationHandler",
									},
									"InstanceCacheHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceCacheHandler",
									},
									"InstanceAssignmentHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceAssignmentHandler",
									},
									"InstanceDestructionHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceDestructionHandler",
									},
									"InstanceBoundaryHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceBoundaryHandler",
									},
									"InstanceLoaderHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstanceLoaderHandler",
									},
									"InstancePlayerCharacterHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/InstanceManager/Handler/InstancePlayerCharacterHandler",
									},
								}
							},
						}
					},
					"ChunkManager": {
						"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager",
						"children": {
							"Handler": {
								"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler",
								"children": {
									"ChunkLifecycleHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkLifecycleHandler",
									},
									"ChunkSceneManager": {
										"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkSceneManager",
									},
									"ChunkCreationHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkCreationHandler",
									},
									"ChunkCacheHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkCacheHandler",
									},
									"ChunkAssignmentHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkAssignmentHandler",
									},
									"ChunkDestructionHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkDestructionHandler",
									},
									"ChunkBoundaryHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkBoundaryHandler",
									},
									"ChunkEventHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkEventHandler",
									},
									"ChunkLoaderHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/ChunkManager/Handler/ChunkLoaderHandler",
									},
								}
							},
						}
					},
					"TriggerManager": {
						"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager",
						"children": {
							"Handler": {
								"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler",
								"children": {
									"TriggerInstanceChangeHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerInstanceChangeHandler",
									},
									"TriggerZoneChangeHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerZoneChangeHandler",
									},
									"TriggerRoomChangeHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerRoomChangeHandler",
									},
									"TriggerEventHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerEventHandler",
									},
									"TriggerTrapHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerTrapHandler",
									},
									"TriggerObjectiveHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerObjectiveHandler",
									},
									"TriggerArea2DCalculationHandler": {
										"path_tree": "/root/Game/GameWorldModule/Manager/TriggerManager/Handler/TriggerArea2DCalculationHandler",
									},
								}
							},
						}
					},
					"SpawnPointManager": {
						"path_tree": "/root/Game/GameWorldModule/Manager/SpawnPointManager",
					},
				}
			},
		}
	},
	"GameLevelModule": {
		"path_tree": "/root/Game/GameLevelModule",
		"children": {
			"Manager": {
				"path_tree": "/root/Game/GameLevelModule/Manager",
				"children": {
					"LevelManager": {
						"path_tree": "/root/Game/GameLevelModule/Manager/LevelManager",
						"children": {
							"Handler": {
								"path_tree": "/root/Game/GameLevelModule/Manager/LevelManager/Handler",
								"children": {
									"LevelCreationHandler": {
										"path_tree": "/root/Game/GameLevelModule/Manager/LevelManager/Handler/LevelCreationHandler",
									},
									"LevelSaveHandler": {
										"path_tree": "/root/Game/GameLevelModule/Manager/LevelManager/Handler/LevelSaveHandler",
									},
									"LevelMapGenerator": {
										"path_tree": "/root/Game/GameLevelModule/Manager/LevelManager/Handler/LevelMapGenerator",
									},
								}
							},
						}
					},
				}
			},
		}
	},
}

var Core = {
	"ServerManager": {
		"path_tree": "/root/Core/ServerManager",
		"children": {
			"PlayerMovementData": {
				"path_tree": "/root/Core/ServerManager/PlayerMovementData",
				"children": {
					"Handler": {
						"path_tree": "/root/Core/ServerManager/PlayerMovementData/Handler",
					},
				}
			},
			"PlayerVisualMonitor": {
				"path_tree": "/root/Core/ServerManager/PlayerVisualMonitor",
				"children": {
					"Handler": {
						"path_tree": "/root/Core/ServerManager/PlayerVisualMonitor/Handler",
					},
				}
			},
		}
	},
	"AudioManager": {
		"path_tree": "/root/Core/AudioManager",
	},
	"Utils": {
		"path_tree": "/root/Core/Utils",
	},
}

var Network = {
	"NetworkGameModule": {
		"path_tree": "/root/Network/NetworkGameModule",
		"children": {
			"Manager": {
				"path_tree": "/root/Network/NetworkGameModule/Manager",
				"children": {
					"NetworkENetServerManager": {
						"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkENetServerManager",
					},
					"NetworkChannelManager": {
						"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkChannelManager",
						"children": {
							"Map": {
								"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkChannelManager/Map",
								"children": {
									"ChannelMap": {
										"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkChannelManager/Map/ChannelMap",
									},
								}
							},
							"Handler": {
								"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkChannelManager/Handler",
							},
						}
					},
					"NetworkPacketManager": {
						"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager",
						"children": {
							"Handler": {
								"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler",
								"children": {
									"PacketDispatchHandler": {
										"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketDispatchHandler",
									},
									"PacketProcessingHandler": {
										"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketProcessingHandler",
									},
									"PacketCreationHandler": {
										"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketCreationHandler",
									},
									"PacketHashHandler": {
										"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketHashHandler",
									},
									"PacketCacheHandler": {
										"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketCacheHandler",
									},
									"PacketConverterHandler": {
										"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketConverterHandler",
									},
									"PacketValidationHandler": {
										"path_tree": "/root/Network/NetworkGameModule/Manager/NetworkPacketManager/Handler/PacketValidationHandler",
									},
								}
							},
						}
					},
				}
			},
			"NetworkHandler": {
				"path_tree": "/root/Network/NetworkGameModule/NetworkHandler",
				"children": {
					"GameCore": {
						"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore",
						"children": {
							"CoreHeartbeatHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CoreHeartbeatHandler",
							},
							"CoreConnectionHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CoreConnectionHandler",
							},
							"CoreDisconnectionHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CoreDisconnectionHandler",
							},
							"CorePingHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CorePingHandler",
							},
							"CoreServerStatusHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CoreServerStatusHandler",
							},
							"CoreErrorHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCore/CoreErrorHandler",
							},
						}
					},
					"GameMovement": {
						"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameMovement",
						"children": {
							"MovementPlayerHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameMovement/MovementPlayerHandler",
							},
							"MovementPlayerSyncHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameMovement/MovementPlayerSyncHandler",
							},
						}
					},
					"GameInstance": {
						"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameInstance",
						"children": {
							"SceneInstanceDataHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameInstance/SceneInstanceDataHandler",
							},
						}
					},
					"GameTrigger": {
						"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameTrigger",
						"children": {
							"TriggerEntryHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameTrigger/TriggerEntryHandler",
							},
							"TriggerExitHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameTrigger/TriggerExitHandler",
							},
							"TriggerInstanceChangeHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameTrigger/TriggerInstanceChangeHandler",
							},
							"TriggerZoneChangeHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameTrigger/TriggerZoneChangeHandler",
							},
							"TriggerRoomChangeHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameTrigger/TriggerRoomChangeHandler",
							},
							"TriggerEventHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameTrigger/TriggerEventHandler",
							},
							"TriggerTrapHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameTrigger/TriggerTrapHandler",
							},
							"TriggerObjectiveHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameTrigger/TriggerObjectiveHandler",
							},
						}
					},
					"GameUser": {
						"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameUser",
						"children": {
							"UserLoginHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameUser/UserLoginHandler",
							},
							"UserTokenHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameUser/UserTokenHandler",
							},
						}
					},
					"GameCharacter": {
						"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCharacter",
						"children": {
							"CharacterFetchHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCharacter/CharacterFetchHandler",
							},
							"CharacterSelectHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCharacter/CharacterSelectHandler",
							},
							"CharacterUpdateHandler": {
								"path_tree": "/root/Network/NetworkGameModule/NetworkHandler/GameCharacter/CharacterUpdateHandler",
							},
						}
					},
				}
			},
			"Config": {
				"path_tree": "/root/Network/NetworkGameModule/Config",
			},
			"Map": {
				"path_tree": "/root/Network/NetworkGameModule/Map",
			},
			"Handler": {
				"path_tree": "/root/Network/NetworkGameModule/Handler",
			},
		}
	},
	"NetworkDatabaseModule": {
		"path_tree": "/root/Network/NetworkDatabaseModule",
		"children": {
			"Manager": {
				"path_tree": "/root/Network/NetworkDatabaseModule/Manager",
				"children": {
					"NetworkMiddlewareManager": {
						"path_tree": "/root/Network/NetworkDatabaseModule/Manager/NetworkMiddlewareManager",
					},
					"NetworkEndpointManager": {
						"path_tree": "/root/Network/NetworkDatabaseModule/Manager/NetworkEndpointManager",
					},
				}
			},
			"NetworkHandler": {
				"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler",
				"children": {
					"DatabaseServer": {
						"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseServer",
						"children": {
							"DatabaseServerAuthHandler": {
								"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseServer/DatabaseServerAuthHandler",
							},
						}
					},
					"DatabaseUser": {
						"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseUser",
						"children": {
							"DatabaseUserLoginHandler": {
								"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseUser/DatabaseUserLoginHandler",
							},
							"DatabaseUserTokenHandler": {
								"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseUser/DatabaseUserTokenHandler",
							},
						}
					},
					"DatabaseCharacter": {
						"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseCharacter",
						"children": {
							"DatabaseCharacterFetchHandler": {
								"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseCharacter/DatabaseCharacterFetchHandler",
							},
							"DatabaseCharacterSelectHandler": {
								"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseCharacter/DatabaseCharacterSelectHandler",
							},
							"DatabaseCharacterUpdateHandler": {
								"path_tree": "/root/Network/NetworkDatabaseModule/NetworkHandler/DatabaseCharacter/DatabaseCharacterUpdateHandler",
							},
						}
					},
				}
			},
			"Handler": {
				"path_tree": "/root/Network/NetworkDatabaseModule/Handler",
			},
			"Config": {
				"path_tree": "/root/Network/NetworkDatabaseModule/Config",
			},
			"Map": {
				"path_tree": "/root/Network/NetworkDatabaseModule/Map",
			},
		}
	},
}


func get_data() -> Dictionary:
	var all_data = {}
	var properties = get_property_list()
		
	for property in properties:
		var property_name = property.name
		var property_value = get(property_name)
			
		if typeof(property_value) == TYPE_DICTIONARY:
			all_data[property_name] = flatten_nested_map(property_value)
		
	return all_data

func flatten_nested_map(nested_map: Dictionary) -> Dictionary:
	var flat_map = {}
		
	for key in nested_map.keys():
		var value = nested_map[key]
		
		if typeof(value) == TYPE_DICTIONARY and value.has('children'):
			flat_map[key] = value
			flat_map[key]['children'] = flatten_nested_map(value['children'])
		else:
			flat_map[key] = value
	
	return flat_map

