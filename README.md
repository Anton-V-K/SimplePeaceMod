# SimplePeaceMod
Factorio mod to support peace mode

## Purpose
This mod lets you focus on creating the factory and avoid distraction by natural enemies.  
Basically it performs following steps:

- Removes (or hides) military-related recipes and technologies (only the ones requires for the rocket launching are kept)
- Clears the map from military equipment and natural enemies (when `assembling-machine`, `furnace`, `mining-drill` or military entity is built)
- Tweaks the [military science pack](https://wiki.factorio.com/Military_science_pack) so it can be produced from the same amount of raw materials

## Compatibility with Factorio
 - [X] 0.16.51
 - [X] 0.17.79 (manually change `factorio_version` in `info.json`)

## Compatibility with other mods

 Mod            | 0.16.x    | 0.17.x
 --------       | -------   | ---
 Aircraft       | ~~1.5.3~~ | ?
 Dectorio       | 0.8.11    | ?
 Factorissimo2  | 2.2.3     | ?
 Map Ping       | 1.0.4     | ?
 ZRecycling     | 0.16.8    | ?

## History

### 0.16.7 (29.03.2020)
- Weapons and enemies are removed when certain production entities are built (workaround for #2)
- Compatibility with Factorio 0.17.x

### 0.16.6 (28.03.2020)
- Weapons and enemies are removed from the map when a military entity is built by the player

### 0.16.5 (28.03.2020)
- Optimization of map cleanup from enemies and weapons (performed during map chunk generation)
- Backward compatibility fixes in recipes and technologies (to support loading of games saved in old versions of Factorio)

## Credits
The work is based on the [Peace Mod](https://mods.factorio.com/mods/cullyn/peacemod), which is deprecated.