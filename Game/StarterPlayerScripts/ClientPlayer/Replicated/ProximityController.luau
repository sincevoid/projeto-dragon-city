--!strict

--[[
    ProximityController
    -------------------
    Manages all ProximityPrompts in the Workspace and executes corresponding actions.
    Now fully scalable to handle multiple teleport types and future actions.

    Requirements:
    - Each ProximityPrompt must have an "ActionName" attribute.
    - Any new teleport action should exist in TeleporterService and be added to the Actions table.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Knit = require(game.ReplicatedStorage.Packages.knit)
local Trove = require(game.ReplicatedStorage.Packages.trove)

local Player = Players.LocalPlayer

local ProximityController = Knit.CreateController({
	Name = "ProximityController",
})

-- Knit Services
local TeleporterService

-- =========================
-- ACTIONS
-- =========================
-- Actions table with type annotation
local Actions: { [string]: (self: table, Player, ...any) -> () } = {
	TeleportOwnIsland = function(_, player: Player)
		TeleporterService:CallTeleport("OwnIsland")
	end,
	TeleportCentral = function(_, player: Player)
		TeleporterService:CallTeleport("Central")
	end,
}
ProximityController.Actions = Actions

-- =========================
-- PROXIMITY PROMPT INSTANCE
-- =========================

--- Creates a new controller instance for a prompt
--- @param prompt ProximityPrompt
--- @return table
function ProximityController.new(prompt: ProximityPrompt)
	local self = setmetatable({}, { __index = ProximityController })
	self.Prompt = prompt
	self._trove = Trove.new()

	-- Connect Triggered event
	self._trove:Connect(prompt.Triggered, function(player)
		self:OnTrigger(player)
	end)

	return self
end

--- Destroys controller resources
function ProximityController:Destroy()
	if self._trove then
		self._trove:Destroy()
	end
end

--- Called when the prompt is triggered
--- @param player Player
function ProximityController:OnTrigger(player: Player)
	local actionName = self.Prompt:GetAttribute("ActionName")
	if not actionName then
		warn("[ProximityController] ProximityPrompt missing 'ActionName' attribute")
		return
	end

	local action = self.Actions[actionName]
	if not action then
		warn("[ProximityController] No action found for ActionName:", actionName)
		return
	end

	action(self, player)
end

-- =========================
-- KNIT LIFECYCLE
-- =========================

function ProximityController:KnitInit()
	-- Nothing here, kept for Knit compatibility
end

function ProximityController:KnitStart()
	print("parou aqui")
	TeleporterService = Knit.GetService("TeleporterService")

	-- Helper to register new prompts
	local function registerPrompt(descendant)
		if not descendant:IsA("ProximityPrompt") then
			return
		end
		if descendant:GetAttribute("Registered") then
			return
		end

		descendant:SetAttribute("Registered", true)
		ProximityController.new(descendant)
		if RunService:IsStudio() then
			_G.print("[ProximityController] Prompt registered:", descendant.Name)
		end
	end

	-- Connect dynamically added prompts
	Workspace.DescendantAdded:Connect(registerPrompt)

	-- Register all existing prompts
	for _, descendant in Workspace:GetDescendants() do
		registerPrompt(descendant)
	end

	if RunService:IsStudio() then
		_G.print("[ProximityController] Running")
	end
end

return ProximityController
