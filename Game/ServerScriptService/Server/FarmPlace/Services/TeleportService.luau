local Knit = require(game.ReplicatedStorage.Packages.knit)

local TeleporterService = Knit.CreateService({
    Name = "TeleporterService",
    Client = {},
})

function TeleporterService.Client:CallTeleport(player: Player, location: string, ...)
    if not location or location == "" then
        return warn("No location provided for teleportation")
    end
    return self.Server:CallTeleport(player, location, ...)
end

function TeleporterService:CallTeleport(player: Player, location: string, ...)
    if not player or not location then
        return warn("Invalid teleportation request")
    end

    -- Aqui você pode adicionar a lógica para teleportar o jogador
    print("chegou aqui")
end

function TeleporterService.KnitInit()
    print("TeleportService initialized")
end

function TeleporterService.KnitStart()
    print("TeleportService is running")
    --> safe para acessar outros controllers
end

return TeleporterService
