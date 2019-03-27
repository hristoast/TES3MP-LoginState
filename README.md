# TES3MP-LoginState

Set up a specific login state for players.

## Installation

1. Place `LoginState.lua` into your `CoreScripts/scripts/custom/` directory.  Symlinks are OK.

1. Add the following to `CoreScripts/scripts/customScripts.lua`:

        require("custom/LoginState")

## Caius Package

Ensures players have the package for Caius when they log on, in case a quest reset was done.  Set `config.ensure_caius_package` to `false` if you don't want this.

## NCGD Compatibility

Lua to support properly initializing NCGD for TES3MP.  Set `LoginState.use_ncgd` to `false` if you don't want this.  Note that NCGD does not currently work, but when it does so too should this lua.
