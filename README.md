# SimplePeaceMod
Factorio mod to support peace mode

## Purpose
This mod lets you focus on creating the factory and avoid distraction by natural enemies.  
Basically it performs following steps:

- Removes (or hides) military-related recipes and technologies (only the ones requires for the rocket launching are kept)
- Clears the map from military equipment and natural enemies (when `assembling-machine`, `furnace`, `mining-drill` or military entity is built)
- Tweaks the [military science pack](https://wiki.factorio.com/Military_science_pack) so it can be produced from the same amount of raw materials

## Compatibility with Factorio
| Mod version   | Factorio version |
| ------------- | ---------------- |
| 0.16.3-0.16.7 | 0.16.51 (*)      |
| 0.17.1        | 0.17.79 (*)      |
| 1.0.0         | 1.0.0            |

(*) The current version (from the master branch) may also work after changing `factorio_version` in `info.json`

## Compatibility with other mods

 Mod                                                                | 0.16.x | 0.17.x| 1.0.x 
 ------------------------------------------------------------------ | ------ | ------ | ------------------------------------------------------------------ 
 [Aircraft](https://github.com/Stifling-Bossness/Aircraft/)         | 1.5.3  | 1.6.12| 1.7.1 
 [Aircraft Realism](https://github.com/jaihysc/Factorio-AircraftRealism) | ? | ? | 1.1.2 
 [Dectorio](https://github.com/jpanther/Dectorio)                   | 0.8.11 | 0.9.16| 0.11.1 
 [Factorissimo2](https://github.com/MagmaMcFry/Factorissimo2)       | 2.2.3  | 2.3.10| 2.4.5 
 [Map Ping](https://github.com/Suprcheese/Map-Ping)                 | 1.0.4  | Not needed| Not needed 
 [Recycling-Machines](https://github.com/DRY411S/Recycling-Machines)| 0.16.8 | 0.17.10| 1.0.4 

## History

### 1.0.0 (08.02.2022)

* Switched to Factorio 1.0.x

### 0.17.1 (08.02.2022)

- Switched to Factorio 0.17.x

### 0.16.7 (29.03.2020)

- Weapons and enemies are removed when certain production entities are built (workaround for #2)
- Compatibility with Factorio 0.17.x
- `control.lua` and `data.lua` were moved into subfolders to be ready for further branching
- TABs were replaced with SPACEs

### 0.16.6 (28.03.2020)
- Weapons and enemies are removed from the map when a military entity is built by the player

### 0.16.5 (28.03.2020)
- Optimization of map cleanup from enemies and weapons (performed during map chunk generation)
- Backward compatibility fixes in recipes and technologies (to support loading of games saved in old versions of Factorio)

## Credits
The work is based on the [Peace Mod](https://mods.factorio.com/mods/cullyn/peacemod), which is deprecated.