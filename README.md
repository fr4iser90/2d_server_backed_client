
# Fun Home Project

**Note:** This project is not working at all (yet!), but hey, at least UDP seems pretty fast! Just having fun and experimenting with some modular stuff.

## Getting Started

Here's how you can start the project (or at least try to) and have fun with it.

### Start the Backend

I put the backend in a Docker container, so you can easily start it using `docker-compose`. Make sure you have Docker installed on your machine.

1. Clone the repo:
   ```bash
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name
   ```

2. Start the backend via Docker:
   ```bash
   docker-compose up --build
   ```

This should spin up the backend server. 

### Start the Project Server (1 time)

1. Open Godot (make sure you have Godot installed).
2. Load the project in Godot.
3. Start the server by running the project as a server.
   - In Godot, go to **Project** -> **Run as Server**.

### Start the Project Client

Once the server is running, do the following to run the client:

1. Start the client by running the project in normal mode (not as a server).
2. Connect to the server (UDP is in place, and somehow that works!).
3. Minimal visuals, but it connects!

### Modular Plans

The idea is to make this project modular and scalable. I'm planning to add:
- **RPG modules**
- **FPS modules**
- And maybe more fun things, like AI-generated stuff.

These modules will be collected and hopefully, you can use them in a modular way for your little home projects, nothing special, just fun stuff.

## Disclaimer

The code is **totally BS**. It’s a mess, and most of it doesn’t work yet. I’m just playing around, so don’t expect anything functional, but feel free to explore!

Enjoy messing around with this chaotic project! :)

