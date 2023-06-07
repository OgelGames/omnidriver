# Omnidriver [omnidriver]

[![luacheck](https://github.com/OgelGames/omnidriver/workflows/luacheck/badge.svg)](https://github.com/OgelGames/omnidriver/actions)
[![License](https://img.shields.io/badge/License-MIT%20and%20CC%20BY--SA%204.0-green.svg)](LICENSE.md)
[![Minetest](https://img.shields.io/badge/Minetest-5.4+-blue.svg)](https://www.minetest.net)
[![ContentDB](https://content.minetest.net/packages/OgelGames/omnidriver/shields/downloads/)](https://content.minetest.net/packages/OgelGames/omnidriver/)

## Overview

It's the ultimate screwdriver. You'll never need another screwdriver.

![Overview Screenshot](screenshot.png?raw=true "Overview Screenshot")

## Features

- The only screwdriver (as far as I know) capable of rotating all 8 rotation types.
- Multiple operation modes, including copy and paste.
- Soft sounds (no more sonic-boom screwdriver).
- Unlimited uses (by default, can be changed with a setting).

## Usage

The omnidriver has four different modes of operation, the first three work similar to each other, while the last one works a bit different.

- Hold the sneak key (default `Shift`) and left-click to cycle between modes.

**Single-axis rotation types**

Because of their simplicity, the behavior for rotating `4dir`, `color4dir`, `degrotate` and `colordegrotate` are the same between all three rotation modes:

- Left-click or right-click to rotate clockwise (as viewed from above).
- Hold the special key (default `E`) to reverse direction.
- For `degrotate` only, right-click allows for more precise rotation.

**1 - Rotate Vertical / Rotate Horizontal**

This is the simplest mode to use, and the most reliable.

- Left-click to rotate clockwise (as viewed from above).
- Right-click to rotate towards yourself (think of a wheel rolling towards you).
- Hold the special key (default `E`) to reverse direction.

**2 - Push Edge / Rotate Pointed**

This mode will be familiar to anyone that has used the [`rhotator`](https://content.minetest.net/packages/entuland/rhotator/) or [`screwdriver2`](https://content.minetest.net/packages/12Me21/screwdriver2/) mods, as it functions identically. It rotates based on what part of the node you are looking at.

- Left-click to "push" the edge you are looking at away from you.
- Right-click to rotate the face you are looking at clockwise.
- Hold the special key (default `E`) to reverse direction.

**3 - Rotate Face / Rotate Axis**

This mode is identical to the default screwdriver in Minetest Game.

- Left-click to rotate to a different face.
- Right-click to rotate around the node's local "up" axis.
- Hold the special key (default `E`) to reverse direction.

**4 - Paste / Copy**

This mode is used to copy rotation values between nodes. It only works to copy between "compatible" rotation types (for example, it can copy from `facedir` to `colorfacedir`, but not from `facedir` to `degrotate`)

- Left-click to paste a stored rotation to the target node.
- Right-click to copy the rotation of the target node.
- Hold the special key (default `E`) to copy or paste a secondary rotation.

## Dependencies

**Required**

- `default` (included in [Minetest Game](https://github.com/minetest/minetest_game))
- `screwdriver` (included in [Minetest Game](https://github.com/minetest/minetest_game))

## Installation

Download the [master branch](https://github.com/OgelGames/omnidriver/archive/master.zip) or the [latest release](https://github.com/OgelGames/omnidriver/releases), and follow [the usual installation steps](https://wiki.minetest.net/Installing_Mods).

Alternatively, you can download and install the mod from [ContentDB](https://content.minetest.net/packages/OgelGames/omnidriver) or the online content tab in Minetest.

## License

Except for any exceptions stated in [LICENSE.md](LICENSE.md#exceptions), all code is licensed under the [MIT License](LICENSE.md#mit-license), with all textures, models, sounds, and other media licensed under the [CC BY-SA 4.0 License](LICENSE.md#cc-by-sa-40-license). 

