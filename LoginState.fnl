(fn dbg [msg]
  (tes3mp.LogMessage enumerations.log.VERBOSE (.. "[ LoginState ]: " msg)))

(fn LoginState.ensureCaiusPkg [event-status pid]
  "Ensure that the player has the package for Caius Cosades, in the case
   that there was a quest reset and the player already gave him the package."
  (let [caiuspkg "todo"
        caiustopic "report to caius cosades"
        player (. Players pid)]
    (when (= (tableHelper.containsValue WorldInstance.data.topics caiustopic) false)
        (dbg "Quest 'report to caius' has not been completed!")
        (local has-pkg (inventoryHelper.getItemIndexplayer.data.inventory "bk_a1_1_caiuspackage" -1))
        (if has-pkg
            (dbg (.. player.name " has the package for Caius !"))
            (do
              (dbg (.. "Ensuring the caius package in "  player.name "'s inventory !"))
              (table.insert player.data.inventory caiuspkg)
              (player:LoadInventory)
              (player:LoadEquipment))))))

(customEventHooks.registerHandler "OnPlayerAuthentified" LoginState.ensureCaiusPkg)
