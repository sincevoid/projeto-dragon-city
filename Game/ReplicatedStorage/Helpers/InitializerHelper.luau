local RunService = game:GetService("RunService")


local Helper = {}

---  ### Moves all children of a given Instance to a new Parent
--- @param target Instance The children of **which** Intance you wanted to move
--- @param newChildParent Instance The new parent of these children
--- @param destroy boolean (OPTIONAL) If you want to destroy the **target** after moving his children 
--- @return nil
function Helper:moveChildren(target : Instance, newChildParent : Instance, destroy : boolean?)
    if #target:GetChildren() > 0 then
        for _,v in pairs(target:GetChildren()) do
            v.Parent = newChildParent
        end
        if destroy then
            target:Destroy()
        end
    end
end


--- ### Replicate given knit components to a init component
--- @param itemsT table
--- @param initComponent Instance 
--- @return nil
--- 
--- ## *Application:*
--- ```lua
--- local componentsTable = {a, b, c} : {number : ModuleScript}
--- local initComponent = IdkScript : Script -- Can't be in runtime script
--- Helper:AddReplicatedKnitComponents(componentsTable, initComponent) --- Move all ModulesScripts into the init component
---`
function Helper:AddReplicatedKnitComponents(itemsT : {number : ModuleScript}, initComponent : Script | LocalScript | Folder )
    
    assert(initComponent, "Needs a initComponent")
    assert(type(itemsT) == "table", "Invalid value provided on argument #1") 
    assert(initComponent.ClassName == "Script" or "LocalScript" or "Folder", "Invalid value provided on argument #2")
    assert(initComponent.Name == self:GetKnitGroupComponentName(), string.format("Invalid initComponent, expected %s got %s", self:GetKnitGroupComponentName(), initComponent.Name))
    
    for _,v in pairs(itemsT) do
        if RunService:IsStudio() then
            if RunService:IsStudio() then
                _G.print(v, initComponent)
            end
        end
        v.Parent = initComponent
    end
end

--- ### Check if the given item is a valid Knit component
--- Determines whether an `Instance` or string represents a valid Knit Service (server)
--- or Controller (client). Works dynamically depending on runtime context.
---
--- @param item Instance | string  -- The item to verify (usually a ModuleScript, but may be a string)
--- @return boolean                -- Returns `true` if the item name ends with "Service" (server) or "Controller" (client)
---
--- ## *Application:*
--- ```lua
--- -- Example 1: Checking a Controller on the client
--- local isController = Helper:IsAKnitComponent(someModule)
--- if isController then
---     _G.print("Valid Knit Controller detected!")
--- end
---
--- -- Example 2: Checking a Service on the server
--- local isService = Helper:IsAKnitComponent(serviceModule)
--- if isService then
---     _G.print("Valid Knit Service detected!")
--- end
--- ```
---
--- **Notes:**
--- - On the client, searches for `"Controller"` at the end of the module name.
--- - On the server, searches for `"Service"` at the end of the module name.
--- - Case-insensitive comparison.
--- - Returns `false` for any non-ModuleScript or unrelated items.
function Helper:IsAKnitComponent(item : Instance | string)
    if not item:IsA("ModuleScript") and type(item) ~= "string" then return false end

    if RunService:IsClient() then
       local p_start, p_end = string.find(string.lower(item.Name), "controller") 
       if p_start then
            if p_start > 1 and p_end == string.len(item.Name) then
                return true
            end    
       end
    else
        local p_start, p_end = string.find(string.lower(item.Name), "service") 
        if p_start then
             if p_start > 1 and p_end == string.len(item.Name) then
                 return true
             end    
        end
    end
    return false
end

--- ### Get the Knit component group name based on the current runtime environment
--- Returns the correct Knit group name ("Services" or "Controllers") depending on whether
--- the code is executing on the server or on the client.
---
--- @return string  -- `"Services"` when on the server, `"Controllers"` when on the client
---
--- ## *Application:*
--- ```lua
--- local groupName = Helper:GetKnitGroupComponentName()
--- _G.print(groupName) 
--- -- Output example:
--- -- "Services" (if running on server)
--- -- "Controllers" (if running on client)
--- ```
---
--- **Notes:**
--- - Useful for dynamically referencing Knit folders or components.
--- - Uses `RunService:IsServer()` to determine the execution context.
function Helper:GetKnitGroupComponentName()
    if RunService:IsServer() then
        return "Services"
    else
        return "Controllers"
    end
end

--- ### Get the current load state of a script
--- Determines the appropriate load status of a script depending on whether
--- it's running on the server or the client.  
--- On the client, it checks the script's parent hierarchy to infer whether
--- the Player, Character, or UI has been loaded.
---
--- @param script Instance  -- The script instance to check (usually a LocalScript or Script)
--- @return string          -- Returns one of: `"ServerLoaded"`, `"ClientCharacterLoaded"`, `"ClientPlayerLoaded"`, or `"ClientUILoaded"`
---
--- ## *Application:*
--- ```lua
--- local status = Helper:GetLoadValue(script)
--- _G.print(status)
--- -- Output examples:
--- -- "ServerLoaded"            -> When running on the server
--- -- "ClientCharacterLoaded"   -> When script is under the player's Character
--- -- "ClientPlayerLoaded"      -> When script is under PlayerScripts
--- -- "ClientUILoaded"          -> When script is under PlayerGui
--- ```
---
--- **Notes:**
--- - Uses `RunService:IsServer()` to distinguish between server and client.
--- - On client-side, detects script context using `IsDescendantOf` hierarchy checks.
--- - Intended for use in debugging or initializing Knit component states.
function Helper:GetLoadValue(script : Instance)
    if RunService:IsServer() then
        return "ServerLoaded"
    else
        local plr = game.Players.LocalPlayer
        if script:IsDescendantOf(plr.Character) and not script:IsDescendantOf(plr.PlayerScripts) then
            return "ClientCharacterLoaded"
        end
        if script:IsDescendantOf(plr.PlayerScripts) then
            return "ClientPlayerLoaded"
        end
        if script:IsDescendantOf(plr.PlayerGui) then
            return "ClientUILoaded"
        end
    end
end

return Helper