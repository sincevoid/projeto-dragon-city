local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PlaceDetector = require(REPLICATED_STORAGE.Shared:WaitForChild("PlaceDetector"))
local Helper = require(REPLICATED_STORAGE.Shared.Helpers.InitializerHelper)

local KnitComponents = {}
local initComponent = nil

if not game:IsLoaded() then
    game.Loaded:Wait()
end

for placeName, value : Instance in pairs(script.Parent.ClientPlayer:GetChildren()) do
    if value.Name == "Replicated" then
        for _, item in ipairs(value:GetChildren()) do
            if RunService:IsStudio() then
                print(string.format("Item %s (%s): %*", item.Name, item.ClassName, Helper:IsAKnitComponent(item)))
            end
            if Helper:IsAKnitComponent(item) then
                table.insert(KnitComponents, item)
            end
        end
        continue
    end

    if value:GetAttribute("PlaceId") ~= PlaceDetector:GetCurrentPlaceId() then
        value:Destroy()
        continue
    end

    for _, descendant in ipairs(value:GetDescendants()) do
        if descendant.Parent == value then
            Helper:moveChildren(descendant.Parent, script.Parent.ClientPlayer, true)
            if string.lower(descendant.Name) == string.lower(Helper:GetKnitGroupComponentName()) then
                initComponent = descendant
            end
        end
    end
end

print(Helper:GetLoadValue(script))
Helper:AddReplicatedKnitComponents(KnitComponents, initComponent)

REPLICATED_STORAGE:SetAttribute(Helper:GetLoadValue(script), true)