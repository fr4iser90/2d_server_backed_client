# Fun Home Project

**Note:** This project is still a work in progress and is not fully functional yet. I’m currently experimenting with modular design and exploring UDP communication. While it may not be fully operational, it’s a great learning experience!

**Core Projects:**
- Backend: NodeJS
- Server: Godot (4.2.2)
- Client: Godot (4.2.2)

**Core Systems:**
- Backend: Saving Data / UserLogin etc / CharacterData (needs to be refactored to be modular and scalable)
- Server/Client: Communication via UDP (ENet peer protocol or similar)

## Getting Started

Here's how you can start the project (or at least try to) and have fun with it.

### Start the Backend

I put the backend in a Docker container, so you can easily start it using `docker compose`. Make sure you have Docker installed on your machine.

1. Clone the repo:
   git clone https://github.com/fr4iser90/2d_server_backed_client.git
   cd 2d_backend_server_client

2. Start the backend Server (Backend folder) (collects and saves data for persistence) via Docker:
   docker compose up --build

This should spin up the backend server.

### Start the Project Server

   Connect the Server to backend

### Start the Project Client

   Connect with test data or something else to Server (when connection to backend established)

Once the server is running, do the following to run the client:

### My Plans/ To-dos

<details>
  <summary>Modularize overall Features</summary>
- Choose Between: Backend Database usage or not, Websocket, REST API, Modules etc...
- Refactor Client / Server
- Client: Refactor to launcher fetch data, cache everything build Client)
- Server: Refactor to Builder , Save Builds on Modules, show presets
</details>

<details>
  <summary>Network Features</summary>
- ChannelSystem: Started
- PacketSystem: Started
- RoutingBackendSystem: Started
- HandlerControllerSystem: To be implemented
- SecurePackets/Hash: To be implemented
</details>

<details>
  <summary>Implement Global Features</summary>
Implement Global Features
- SceneSystem: Started
- NodeSystem: Started
- InstanceSystem: Started
- SignalSystem: To be implemented
- ModuleCompatibilySystem: To be implemented
- ModuleConverter: To be implemented
- HandlerControllerSystem
- WorkflowSystem for:
- SceneImport/Mapping/Generating
- Implementing Modules/Middleware
</details>

<details>
  <summary>Implement Server Features</summary>
Implement Server Features
- NetworkBackendSystem REST API: Started
- NetworkBackendSystem Websocket: To be implemented
- NetworkClientSystem ENetPacketPeer: Started
- NetworkClientSystem MultiplayerApi: To be implemented
- PlayerMonitor: Started
- PlayerVisualMonitor: Started
- ValidationSystem: To be implemented
</details>

<details>
  <summary>Implement Game Features</summary>
Implement Game Features
- UserSystem: Started
- MovementSystem2D: Started
- MovementSystem3D: To be implemented
- MovementSystemPlatformer2D: To be implemented (considering using manager, saw one very good source)
- CombatSystem: To be implemented
- CharacterSystem: To be implemented
- InventorySystem: To be implemented
- CraftSystem: To be implemented
- SpawnSystem: Started
- Group/TeamSystem: To be implemented
- GuildSystem: To be implemented
- StashSystem: To be implemented
- MapgenSystem: Considering using Godot MapCrafter V1,thanks to https://github.com/aimforbigfoot  )
</details>

Goal:
- a preset for RogueLite

### Modular Plans

The idea is to make this project modular and scalable. I'm planning to add:
- RPG modules
- AUTOBATTLER modules
- FPS modules
- ...
- And maybe more fun things, like AI-generated stuff.

These modules will be collected and hopefully, you can use them in a modular way for your little home projects. Nothing special, just fun stuff.

## Disclaimer

The code is currently a work in progress and is not fully functional. I’m in the experimental phase, so things might be messy and incomplete. I’m learning and exploring, and I appreciate any feedback or suggestions you might have.

Enjoy messing around with this chaotic project! :)
