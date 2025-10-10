local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local PlaceDetector = require(REPLICATED_STORAGE.Shared:WaitForChild("PlaceDetector"))

if not game:IsLoaded() then
    game.Loaded:Wait()
end

--- *Moves all children of a given Instance to a new Parent*
--- @param target Instance The children of **which** Intance you wanted to move
--- @param newChildParent Instance The new parent of these children
--- @param destroy boolean (OPTIONAL) If you want to destroy the **target** after moving his children 
--- @return nil
function moveChildren(target : Instance, newChildParent : Instance, destroy : boolean?)
    if #target:GetChildren() > 0 then
        for i,v in pairs(target:GetChildren()) do
            v.Parent = newChildParent
        end
        if destroy then
            target:Destroy()
        end
    end
end

for placeName, value : Instance in pairs(script.Parent.ClientPlayer:GetChildren()) do
    if value.Name == "Replicated" then
        continue
    end

    if value:GetAttribute("PlaceId") ~= PlaceDetector:GetCurrentPlaceId() then
        value:Destroy()
        continue
    end

    for _, descendant in ipairs(value:GetDescendants()) do
        if descendant.Parent == value then
            moveChildren(descendant.Parent, script.Parent.ClientPlayer, true)
        end
    end

    REPLICATED_STORAGE:SetAttribute("ClientPlayerLoaded", true)
end