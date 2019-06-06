# TES3MP-LoginState

Set up a specific login state for players.

## Installation

1. Place `LoginState.lua` into your `CoreScripts/scripts/custom/` directory.

1. Add the following to `CoreScripts/scripts/customScripts.lua`:

        require("custom/LoginState/main")

## Caius Package

Ensures players have the package for Caius when they log on, in case a quest reset was done.  Set `config.ensure_caius_package` to `false` if you don't want this.
