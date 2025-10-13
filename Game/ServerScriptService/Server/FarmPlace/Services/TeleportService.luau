--[[
    TeleporterService
    -----------------
    Service responsible for managing player teleportation across the game.

    Structure:
    - Client: exposes remote methods accessible by clients (e.g., CallTeleport).
    - Server: handles the actual teleportation logic.
    - CallTeleport: validates parameters and executes teleportation to a defined destination.

    Example usage (on the client):
        local TeleporterService = Knit.GetService("TeleporterService")
        TeleporterService:CallTeleport("OwnIsland")
]]

local Knit = require(game.ReplicatedStorage.Packages.Knit)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local TeleporterService = Knit.CreateService({
    Name = "TeleporterService",
    Client = {},
})

--[[
    CLIENT METHODS
    --------------
    Functions exposed to the client. Knit automatically handles replication.
]]

--- Called remotely by the client to initiate a teleport.
--- @param player Player The player who requested the teleport
--- @param location string The destination key (e.g. "OwnIsland")
--- @return any
function TeleporterService.Client:CallTeleport(player: Player, location: string, ...)
    if not location or location == "" then
        warn("[TeleporterService] No teleport destination specified.")
        return
    end

    return self.Server:CallTeleport(player, location, ...)
end


--[[
    SERVER METHODS
    --------------
    Core teleportation logic handled securely on the server.
]]

--- Executes the actual teleportation of a player.
--- @param player Player The player to teleport
--- @param location string The destination identifier
--- @return nil
function TeleporterService:CallTeleport(player: Player, location: string, ...)
    if not player or not location then
        warn("[TeleporterService] Invalid teleportation request.")
        return
    end

    if not player:IsDescendantOf(Players) then
        warn(string.format("[TeleporterService] Invalid or disconnected player: %s", tostring(player)))
        return
    end

    local destination = self:GetTeleportLocation(location)
    if not destination then
        warn(string.format("[TeleporterService] Destination '%s' not found.", location))
        return
    end

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRoot = character:FindFirstChild("HumanoidRootPart")

    if humanoidRoot then
        humanoidRoot.CFrame = destination.CFrame
        print(string.format("[TeleporterService] %s teleported to '%s'.", player.Name, location))
    else
        warn(string.format("[TeleporterService] Failed to find HumanoidRootPart for '%s'.", player.Name))
    end
end

--- Finds and returns a teleport destination by name.
--- @param locationName string The name of the teleport location
--- @return BasePart? The BasePart representing the destination, or nil if not found
function TeleporterService:GetTeleportLocation(locationName: string): BasePart?
    local teleportsFolder = Workspace:FindFirstChild("Teleports")
    if not teleportsFolder then
        warn("[TeleporterService] 'Teleports' folder not found in Workspace.")
        return nil
    end

    local destination = teleportsFolder:FindFirstChild(locationName)
    if not destination or not destination:IsA("BasePart") then
        warn(string.format("[TeleporterService] Invalid teleport destination: %s", locationName))
        return nil
    end

    return destination
end


--[[
    KNIT LIFECYCLE METHODS
    ----------------------
    Automatically called by Knit during initialization.
]]

--- Called before Knit services start.
function TeleporterService:KnitInit()
    print("[TeleporterService] Initialized.")
end

--- Called after all Knit services are running.
function TeleporterService:KnitStart()
    print("[TeleporterService] Running.")
end

return TeleporterService
