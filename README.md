# Fun Home Project

**Note:** This project is not working at all (yet!), but hey, at least UDP seems pretty fast! Just having fun and experimenting with some modular stuff.

**Core Projects:**
- Backend: NodeJS
- Server: Godot (4.2.2)
- Client: Godot (4.2.2)

**Core Systems:**
- Backend: Saving Data / UserLogin etc / CharacterData (needs to be refactored to be modular and scalable)
- Server/Client: Communication via UDP (ENet peer protocol or similar), Global Scene Node Manager (considering adding a Signal Manager), Instance Manager

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

### My Plans
Implement Server Features
-NetworkBackendSystem(started)
-NetworkClientSysem(started)
-PlayerMonitor(started)
-PlayerVisualMonitor(started)
-Routing/ChannelSystem(started)
-SecurePackets/Hash?
-ValidationSystem

Implement Global Features
-MovementSystem2D
-MovementSystem3D
-UserSystem(started)
-InstanceSystem
-SceneSystem
-NodeSysem
-MapgenSystem( consider using Godot MapCrafter V1,thanks to https://github.com/aimforbigfoot  )

Implement Multiplayer Roguelite Features
-MovementSystem(started)
-CombatSystem
-CharacterSystem
-InventorySystem
-CraftSystem
-SpawnSystem(started)
-Group/TeamSystem
-GuildSytem
-StashSystem
### Modular Plans

The idea is to make this project modular and scalable. I'm planning to add:
- RPG modules
- AUTOBATTLER modules
- FPS modules
- ...
- And maybe more fun things, like AI-generated stuff.

These modules will be collected and hopefully, you can use them in a modular way for your little home projects. Nothing special, just fun stuff.

## Disclaimer

The code is **totally BS**. It’s a mess, and most of it doesn’t work yet. I’m just playing around, so don’t expect anything functional, but feel free to explore!

Enjoy messing around with this chaotic project! :)
