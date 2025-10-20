-- BeltService.lua
local Knit = require(game.ReplicatedStorage.Packages.knit)
local BeltSystem = require(game.ReplicatedStorage.BeltSystem)
local EggRarityModule = require(game.ReplicatedStorage.EggRarityModule)

local BeltService = Knit.CreateService({
	Name = "BeltService",
	Client = {},
})

local playerBelts = {}

function BeltService:CreateBeltForPlayer(player: Player, waypointsFolder: Folder, speed: number, spawnRate: number)
	local parts = waypointsFolder:GetChildren()
	local belt = BeltSystem.new(player, parts, speed, spawnRate, EggRarityModule)
	belt:Start()
	playerBelts[player.UserId] = belt
	return belt
end

function BeltService:GetBelt(player: Player)
	return playerBelts[player.UserId]
end

function BeltService:RemoveBelt(player: Player)
	local belt = playerBelts[player.UserId]
	if belt then
		belt:Stop()
		playerBelts[player.UserId] = nil
	end
end

function BeltService:KnitStart()
	game.Players.PlayerRemoving:Connect(function(player)
		self:RemoveBelt(player)
	end)
end

return BeltService
