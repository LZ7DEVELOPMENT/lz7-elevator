# Local publication checklist

This file records preparation steps. It does not mean the resource has been published or tested in FiveM.

## Repository setup

- Intended repository: `LZ7DEVELOPMENT/lz7-elevator`.
- Suggested description: Standalone FiveM elevator resource with a configurable NUI keypad, multiple destinations and screen-fade travel.
- Suggested topics: `fivem`, `lua`, `elevator`, `nui`, `standalone`.
- Suggested first release tag: `v1.0.0` (matches `fxmanifest.lua`).
- Choose usage/license terms before publishing and verify the origin and redistribution rights of bundled assets, including `html/elevator.ogg`.
- Use the clean release ZIP as the basis for a new repository if you do not want the old VSH repository history. The local working repository still has its original history and remote configuration.
- Do not push to the original remote by accident. This preparation does not change Git remotes, make commits, create tags or publish releases.
- The previous promotional PNG is retained locally but excluded from the clean package; use `assets/banner.svg` instead.

## Required in-game checks before calling this a tested release

- [ ] Start `lz7-elevator` without manifest or script errors.
- [ ] Verify all destinations with the intended map/MLO loaded.
- [ ] Open the panel with E near each configured floor.
- [ ] Enter valid floor IDs with both keyboard and mouse.
- [ ] Verify floor 0 and a two-digit floor ID if configured.
- [ ] Verify invalid-floor and current-floor feedback.
- [ ] Close using Escape and X; confirm normal game input returns.
- [ ] Confirm audio, fade timing, destination position and heading.
- [ ] Check behavior when the resource is restarted while its panel is open.
- [ ] Check repeated confirmation input during travel.

## Known UI details

The existing keypad includes two buttons for floor digit 6. This preparation preserves the runtime layout and behavior; decide whether to revise it in a separate functional change.

The client does not implement a travel-in-progress lock or an explicit resource-stop focus cleanup handler. The last two checks above remain necessary; do not claim that they passed without testing in FiveM.
