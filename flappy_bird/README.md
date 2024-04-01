# Flappy Bird

Flappy Bird implementation based on tutorial [How to make Flappy Bird in Godot 4](https://youtu.be/lkDvTdbOIEo) 
from [CyberPotato](https://www.youtube.com/@CyberPotatoDev)

## Environment Setup

### Dependencies

- aseprite

### Setup

aseprite binary should be accessible in the PATH

## Project Structure

According to Godot's docs:

```text
/project.godot
/docs/.gdignore  # See "Ignoring specific folders" below
/docs/learning.html
/models/town/house/house.dae
/models/town/house/window.png
/models/town/house/door.png
/characters/player/cubio.dae
/characters/player/cubio.png
/characters/enemies/goblin/goblin.dae
/characters/enemies/goblin/goblin.png
/characters/npcs/suzanne/suzanne.dae
/characters/npcs/suzanne/suzanne.png
/levels/riverdale/riverdale.scn
```

## Roadmap

### Tutorial roadmap

- [X] Creating the bird
- [X] Creating the ground
- [X] Spawning the pipes
- [X] GameManager
- [X] Fade Effect
- [X] Adding the UI

### Ideas

- [ ] crash animation with a bit of gore
	- [ ] camera shake
- [ ] Coruja farting character
- [ ] different kinds of obstacles
	- [ ] Parque das Aguas Totem
- [ ] collectibles
	- [ ] power ups
- [ ] new levels
- [ ] more characters and character select screen

## Plugins

- <https://github.com/viniciusgerevini/godot-aseprite-wizard>

## Other References

- [Godot best practices: project organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html)
