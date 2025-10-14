--!strict

--[[ 
    TeleporterService
    -----------------
    Professional, scalable service for teleporting players.
    Supports any number of teleport destinations with handlers.

    Features:
    - Handles "OwnIsland", "Central", and generic Workspace.Teleports parts.
    - Easily extendable by adding new keys to the handlers table.
    - Works with client calls via Knit Client.
]]

local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local TeleporterService = Knit.CreateService({
	Name = "TeleporterService",
	Client = {},
})

-- Dependencies
local IslandService

-- Default teleport handlers table
-- Key = teleport type / location name
-- Value = function(player: Player)
local TeleportHandlers: { [string]: (Player) -> () } = {}

-- =========================
-- PRIVATE HELPERS
-- =========================

--- Teleports a player to a given CFrame
local function teleportPlayerToCFrame(player: Player, cframe: CFrame)
	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart", 5)
	if not root then
		warn(string.format("[TeleporterService] Missing HumanoidRootPart for '%s'.", player.Name))
		return
	end

	root.CFrame = cframe + Vector3.new(0, 5, 0) -- Safety offset
end

--- Retrieves a part from Workspace.Teleports by name
local function getWorkspaceTeleport(locationName: string): BasePart?
	-- Only try generic teleports, not OwnIsland or Central
	if locationName == "OwnIsland" or locationName == "Central" then
		return nil
	end

	local folder = Workspace:FindFirstChild("Teleports")
	if not folder then
		warn("[TeleporterService] 'Teleports' folder not found for generic teleport: " .. locationName)
		return nil
	end

	local part = folder:FindFirstChild(locationName)
	if part and part:IsA("BasePart") then
		return part
	end

	warn(string.format("[TeleporterService] Teleport part '%s' invalid or missing.", locationName))
	return nil
end

-- =========================
-- TELEPORT HANDLERS
-- =========================

-- Own island teleport
TeleportHandlers["OwnIsland"] = function(player: Player)
	local island = IslandService:GetIsland(player)
	if island then
		local spawn = island:FindFirstChild("Spawn") or island.PrimaryPart
		if spawn then
			teleportPlayerToCFrame(player, spawn.CFrame)
		end
	end
end

TeleportHandlers["Central"] = function(player: Player)
	local centralSpawn = workspace:FindFirstChild("StaticIslands")
		and workspace.StaticIslands:FindFirstChild("Central")
		and workspace.StaticIslands.Central:FindFirstChild("SpawnLocation")
	if centralSpawn then
		teleportPlayerToCFrame(player, centralSpawn.CFrame)
	end
end

TeleportHandlers["OtherPlayerIsland"] = function(player: Player, targetPlayer: Player)
	local island = IslandService:GetIsland(targetPlayer)
	if island then
		local spawn = island:FindFirstChild("Spawn") or island.PrimaryPart
		if spawn then
			teleportPlayerToCFrame(player, spawn.CFrame)
		end
	end
end

-- =========================
-- SERVER METHODS
-- =========================

--- Teleports a player based on a location key
--- @param player Player
--- @param location string The teleport key (OwnIsland, Central, or any Workspace.Teleports part)
function TeleporterService:CallTeleport(player: Player, location: string, ...)
	if not player or not location then
		warn("[TeleporterService] Invalid teleport request.")
		return
	end
	if not player:IsDescendantOf(Players) then
		warn(string.format("[TeleporterService] Player disconnected or invalid: %s", tostring(player)))
		return
	end

	-- Determine the handler
	local handler = TeleportHandlers[location] or TeleportHandlers["Generic"]
	handler(player, location)
end

-- =========================
-- CLIENT METHODS
-- =========================

function TeleporterService.Client:CallTeleport(player: Player, location: string)
	if not location or location == "" then
		warn("[TeleporterService] No teleport location specified.")
		return
	end
	return self.Server:CallTeleport(player, location)
end

-- =========================
-- KNIT LIFECYCLE
-- =========================

function TeleporterService:KnitInit()
	if RunService:IsStudio() then
		_G.print("[TeleporterService] Initialized.")
	end
end

function TeleporterService:KnitStart()
	IslandService = Knit.GetService("IslandService")
	if RunService:IsStudio() then
		_G.print("[TeleporterService] Running and linked to IslandService.")
	end
end

return TeleporterService
