local LoginState = {}

config.ensure_caius_package = true
LoginState.ncgd_init_ran = false
LoginState.use_ncgd = true

local function dbg(msg)
   --[[ Convenient logging wrapper. ]]--
   tes3mp.LogMessage(enumerations.log.VERBOSE, "UniqueItems: " .. msg)
end

local function warn(msg)
   --[[ Convenient logging wrapper. ]]--
   tes3mp.LogMessage(enumerations.log.WARN, "UniqueItems: " .. msg)
end

local function info(msg)
   --[[ Convenient logging wrapper. ]]--
   tes3mp.LogMessage(enumerations.log.INFO, "UniqueItems: " .. msg)
end

local function savePlayer(player)
   -- TODO: Implement this as a class method
   player:SaveAttributes()
   player:LoadInventory()
   player:LoadEquipment()
   player:LoadQuickKeys()
end

LoginState.ensureCaiusPkg = function(eventStatus, pid)
   --[[
      Ensure that the player has the package for Caius Cosades,
      in the case that there was a quest reset and the player
      already gave him the package.
   --]]
   if config.ensure_caius_package then
      local caiuspkg = { refId = "bk_a1_1_caiuspackage", count = 1, charge = -1 }
      local player = Players[pid]

      if tableHelper.containsValue(WorldInstance.data.topics, "report to caius cosades") == false then
         dbg("LoginState: Quest 'report to caius' has not been completed!")
         local hasPkg = inventoryHelper.getItemIndex(player.data.inventory, "bk_a1_1_caiuspackage", -1)
         if hasPkg then
            dbg("LoginState: " .. player.accountName .. " has the package for Caius !")
         else
            dbg("LoginState: Ensuring the caius package in " .. player.accountName .."'s inventory !")
            table.insert(player.data.inventory, caiuspkg)

            savePlayer(player)
         end
      end
   end
end

function LoginState.runNCGD_Init(eventStatus, pid)
   --[[
      For use with https://modding-openmw.com/mods/ncgd-alt-start-patched-for-tes3mp/

      This method triggers the script needed to init NCGD leveling.
   --]]
   if LoginState.use_ncgd then
      dbg("LoginState: Running the script 'NCGD_Init' on player \"".. Players[pid].accountName .."\".")
      logicHandler.RunConsoleCommandOnPlayer(pid, "player->StartScript, NCGD_Init")
      LoginState.ncgd_init_ran = true
   end
end

function LoginState.runNCGD_Run(eventStatus, pid)
   --[[
      For use with https://modding-openmw.com/mods/ncgd-alt-start-patched-for-tes3mp/

      This method triggers the script needed to init NCGD leveling.
   --]]
   if LoginState.use_ncgd and not LoginState.ncgd_init_ran then
      -- We need higher values!
      config.maxAttributeValue = config.maxAttributeValue * 10
      config.maxSpeedValue = config.maxSpeedValue * 10
      config.maxSkillValue = config.maxSkillValue * 10
      config.maxAcrobaticsValue = config.maxAcrobaticsValue * 10

      dbg("LoginState: Running the script 'NCGD_Run' on player \"".. Players[pid].accountName .."\".")
      logicHandler.RunConsoleCommandOnPlayer(pid, "player->StartScript, NCGD_Run")
   end
end

-- Ensure the Caius package
customEventHooks.registerHandler("OnPlayerAuthentified", LoginState.ensureCaiusPkg)

-- NCGD hooks
customEventHooks.registerHandler("OnPlayerEndCharGen", LoginState.runNCGD_Init)
customEventHooks.registerHandler("OnPlayerAuthentified", LoginState.runNCGD_Run)
