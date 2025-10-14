local REPLICATED_STORAGE = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PlaceDetector = require(REPLICATED_STORAGE.Shared:WaitForChild("PlaceDetector"))
local Helper = require(REPLICATED_STORAGE.Shared.Helpers.InitializerHelper)

local KnitComponents = {}
local initComponent = nil

_G.print = function(...)
	if RunService:IsStudio() then
		print(...)
	end
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end

for _, group in pairs(script.Parent.ClientPlayer:GetChildren()) do
	if group.Name == "Replicated" then
		for _, item in ipairs(group:GetChildren()) do
			if RunService:IsStudio() then
				print(
					string.format(
						"Item %s (%s): %s",
						item.Name,
						item.ClassName,
						tostring(Helper:IsAKnitComponent(item))
					)
				)
			end

			if Helper:IsAKnitComponent(item) then
				table.insert(KnitComponents, item)
			end
		end
		continue
	end

	local placeId = group:GetAttribute("PlaceId")
	if placeId ~= PlaceDetector:GetCurrentPlaceId() then
		group:Destroy()
		continue
	end

	for _, descendant in ipairs(group:GetDescendants()) do
		if descendant.Parent == group then
			initComponent = descendant.Parent:FindFirstChild(Helper:GetKnitGroupComponentName())
			Helper:moveChildren(descendant.Parent, script.Parent.ClientPlayer, true)
		end
	end
end
Helper:AddReplicatedKnitComponents(KnitComponents, initComponent)

REPLICATED_STORAGE:SetAttribute(Helper:GetLoadValue(script), true)
