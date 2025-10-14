--!strict

local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local IslandService = Knit.CreateService({
	Name = "IslandService",
	Client = {},
})

-- // PRIVATE CONSTANTS // --
local ISLAND_TEMPLATE = ReplicatedStorage:WaitForChild("IslandTemplate")
local ISLAND_FOLDER = Workspace:FindFirstChild("PlayerIslands") or Instance.new("Folder")
ISLAND_FOLDER.Name = "PlayerIslands"
ISLAND_FOLDER.Parent = Workspace

-- Distance offset between islands to prevent overlap
local ISLAND_SPACING = 2000

-- // PRIVATE STATE // --
local PlayerIslands: { [Player]: Model } = {}

-- // PRIVATE FUNCTIONS // --

--- ### Generate a unique position for a player's island
--- Generates a position based on the current player count to ensure
--- islands are spaced apart in the world.
---
--- @param index number -- The index representing the player's position in the session
--- @return Vector3 -- A Vector3 position where the island should be placed
---
--- ## Application:
---
--- local pos = GenerateIslandPosition(3)
--- _G._G.print(pos)
--- -- Output example:
--- -- Vector3.new(6000, 0, 0)
---
--- Notes:
--- - Uses a simple offset formula to ensure spacing.
--- - Can be expanded to use patterns (e.g., grid or circular layouts).
local function GenerateIslandPosition(index: number): Vector3
	return Vector3.new(index * ISLAND_SPACING, 0, 0)
end

--- ### Create a new island for a player
--- Clones the island template from ReplicatedStorage, positions it safely in the world,
--- and stores it in the service’s internal table.
---
--- @param player Player -- The player to assign the island to
---
--- ## Application:
---
--- IslandService:CreateIsland(player)
---
--- Notes:
--- - Automatically called when a player joins.
--- - Islands are named after the player’s UserId.
function IslandService:CreateIsland(player: Player)
	local index = #Players:GetPlayers()
	local position = GenerateIslandPosition(index)
	local island = ISLAND_TEMPLATE:Clone()

	island.Name = "Island_" .. player.UserId
	island:PivotTo(CFrame.new(position))
	island.Parent = ISLAND_FOLDER

	PlayerIslands[player] = island
end

--- ### Remove a player's island
--- Destroys the player’s island model from the workspace and removes
--- the reference from the internal table.
---
--- @param player Player -- The player whose island will be removed
---
--- ## Application:
---
--- IslandService:RemoveIsland(player)
---
--- Notes:
--- - Called automatically on PlayerRemoving.
--- - Safe to call manually if cleanup is needed.
function IslandService:RemoveIsland(player: Player)
	local island = PlayerIslands[player]
	if island and island.Parent then
		island:Destroy()
	end
	PlayerIslands[player] = nil
end

--- ### Get a player's island
--- Retrieves the player's island model instance.
---
--- @param player Player -- The player to get the island of
--- @return Model? -- Returns the island model, or nil if not found
---
--- ## Application:
---
--- local island = IslandService:GetIsland(player)
--- if island then
---     _G.print("Island found:", island.Name)
--- end
---
--- Notes:
--- - Only returns the island model reference.
--- - Returns nil if the island hasn’t been created yet.
function IslandService:GetIsland(player: Player): Model?
	return PlayerIslands[player]
end

-- // LIFECYCLE EVENTS // --

Players.PlayerAdded:Connect(function(player)
	IslandService:CreateIsland(player)
end)

Players.PlayerRemoving:Connect(function(player)
	IslandService:RemoveIsland(player)
end)

--- ### Knit Service Initialization
--- Called automatically by Knit when the service starts.
---
--- @return nil
---
--- ## Application:
---
--- Called internally by Knit; you do not need to invoke it manually.
---
--- Notes:
--- - Use this for any setup logic before the service starts.
function IslandService:KnitStart()
	if RunService:IsStudio() then
		_G.print("[IslandService] Initialized successfully.")
	end
end

return IslandService
