# Mad Carousel - Source Code

This repository contains the source files for a multiplayer carousel-style game that includes several game modes **(Classic Mingle, Battle Royale, Sweeper, etc.)**, a gamepass & cash shops, leaderboards, and other server / client logic.

_Note that this project only contains the source files and not the models, assets, or other resources needed to run the game in Roblox Studio. This repository exists as a display of the code structure and logic._

---

## Key features

- Multiple game modes (see `game/src/ReplicatedStorage/GameModes.luau`)
- Round and vote system (in `ServerScriptService/`), intermissions and music control
- Inventory / gamepass and cash shop handlers
- Leaderboards and badges
- Rojo-friendly project layout for development with Roblox Studio

---

## Project structure (high level)

- `game/src/ReplicatedStorage/` — shared modules and game assets (GameModes, GameModule, Defaults, etc.)
- `game/src/ServerScriptService/` — server-side logic and handlers (Main, RoundModule, GamepassManager, InventoryManager, Badges, Leaderboards, etc.)
- `game/src/StarterGui/` — client UIs and LocalScripts
- `game/src/StarterPlayer/StarterPlayerScripts/` — client-side player scripts
- `game/src/ServerStorage/`, `game/src/Workspace/` — server-side storage and world assets
