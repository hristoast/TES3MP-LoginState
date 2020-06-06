local LoginState = {}


local function dbg(msg)
   --[[ Convenient logging wrapper. ]]--
   tes3mp.LogMessage(enumerations.log.VERBOSE, "[ LoginState ]: " .. msg)
end

LoginState.ensureCaiusPkg = function(eventStatus, pid)
   --[[
      Ensure that the player has the package for Caius Cosades,
      in the case that there was a quest reset and the player
      already gave him the package.
   --]]
   local caiuspkg = { refId = "bk_a1_1_caiuspackage", count = 1, charge = -1 }
   local player = Players[pid]

   if tableHelper.containsValue(WorldInstance.data.topics, "report to caius cosades") == false then
      dbg("Quest 'report to caius' has not been completed!")
      local hasPkg = inventoryHelper.getItemIndex(player.data.inventory, "bk_a1_1_caiuspackage", -1)
      if hasPkg then
         dbg(player.name .. " has the package for Caius !")
      else
         dbg("Ensuring the caius package in " .. player.name .."'s inventory !")
         table.insert(player.data.inventory, caiuspkg)

         player:LoadInventory()
         player:LoadEquipment()
         player:QuickSaveToDrive()
      end
   end
end

-- Ensure the Caius package
customEventHooks.registerHandler("OnPlayerAuthentified", LoginState.ensureCaiusPkg)
