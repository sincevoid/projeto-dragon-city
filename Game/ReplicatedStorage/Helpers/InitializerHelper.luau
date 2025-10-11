local RunService = game:GetService("RunService")


local Helper = {}

--- *Moves all children of a given Instance to a new Parent*
--- @param target Instance The children of **which** Intance you wanted to move
--- @param newChildParent Instance The new parent of these children
--- @param destroy boolean (OPTIONAL) If you want to destroy the **target** after moving his children 
--- @return nil
function Helper:moveChildren(target : Instance, newChildParent : Instance, destroy : boolean?)
    if #target:GetChildren() > 0 then
        for i,v in pairs(target:GetChildren()) do
            v.Parent = newChildParent
        end
        if destroy then
            target:Destroy()
        end
    end
end

function Helper:AddReplicatedKnitComponents(itemsT : {number : ModuleScript}, initComponent : Script | LocalScript | Folder )
    assert(type(itemsT) == "table", "Invalid value provided on argument #1") 
    assert(initComponent.ClassName == "Script" or "LocalScript" or "Folder", "Invalid value provided on argument #2")

    for _,v in pairs(itemsT) do
        print(v, initComponent)
        v.Parent = initComponent
    end
end

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

function Helper:GetKnitGroupComponentName()
    if RunService:IsServer() then
        return "Services"
    else
        return "Controllers"
    end
end

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