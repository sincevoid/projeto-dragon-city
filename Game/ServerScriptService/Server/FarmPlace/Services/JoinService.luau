local Players = game:GetService("Players")

local Knit = require(game.ReplicatedStorage.Packages.knit)

local JoinService = Knit.CreateService({
    Name = "JoinService",
})

function JoinService.OnPlayerJoin(self, player: Player)
    print("Player joined: ", player.Name)
end

function JoinService.OnPlayerLeave(self, player: Player)
    print("Player left: ", player.Name)
end

function JoinService.KnitInit()
    Players.PlayerAdded:Connect(function(player)
        JoinService:OnPlayerJoin(player)
    end)
end

function JoinService.KnitStart()
    print("JoinService is running")
end

return JoinService
