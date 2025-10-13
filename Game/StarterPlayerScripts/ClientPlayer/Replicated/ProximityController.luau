--[[
    ProximityController
    -------------------
    Handles all ProximityPrompts within the Workspace and links them to defined actions.
    Each prompt must contain an "ActionName" attribute that maps to a function in Actions.

    Features:
    - Automatically detects and registers new ProximityPrompts.
    - Supports multiple actions (e.g., teleporting players).
    - Uses Trove for automatic connection and memory cleanup.

    Dependencies:
    - Knit (controller architecture)
    - Trove (resource cleanup)
    - TeleporterService (for teleport actions)
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Knit = require(game.ReplicatedStorage.Packages.Knit)
local Trove = require(game.ReplicatedStorage.Packages.Trove)

local Player = Players.LocalPlayer

local ProximityController = Knit.CreateController({
    Name = "ProximityController",
})

-- Knit services are set during KnitStart
local TeleporterService

--[[
    ACTIONS DICTIONARY
    ------------------
    Maps each possible ActionName to a specific function.
    Each function receives:
        self (ProximityController instance)
        player (Player who triggered the prompt)
]]
ProximityController.Actions = {
    --- Teleports the player to their own island.
    --- @param self table Reference to ProximityController instance
    --- @param player Player The player who triggered the prompt
    TeleportOwnIsland = function(self, player: Player)
        TeleporterService:CallTeleport("OwnIsland")
    end,

    --- Teleports the player to another player’s island.
    --- @param self table Reference to ProximityController instance
    --- @param player Player The player who triggered the prompt
    --- @param target Player The target player whose island will be visited
    TeleportToIsland = function(self, player: Player, target: Player)
        TeleporterService:CallTeleport(target)
    end
}

--[[
    Creates a new ProximityController instance for a specific ProximityPrompt.

    @param prompt ProximityPrompt The prompt being controlled
    @return table ProximityController instance
]]
function ProximityController.new(prompt: ProximityPrompt)
    local self = setmetatable({}, { __index = ProximityController })
    self.Prompt = prompt
    self._trove = Trove.new()

    -- Connects the Triggered event
    self._trove:Connect(prompt.Triggered, function(player)
        self:OnTrigger(player)
    end)

    return self
end

--[[
    Cleans up Trove connections and destroys associated resources.

    @return nil
]]
function ProximityController:Destroy()
    if self._trove then
        self._trove:Destroy()
        self._trove = nil
    end
end

--[[
    Called when a ProximityPrompt is triggered by a player.
    Executes the associated action defined by the "ActionName" attribute.

    @param player Player The player who triggered the prompt
    @return nil
]]
function ProximityController:OnTrigger(player: Player)
    local actionName = self.Prompt:GetAttribute("ActionName")

    if not actionName then
        warn("[ProximityController] ProximityPrompt missing 'ActionName' attribute.")
        return
    end

    local action = self.Actions[actionName]
    if not action then
        warn(string.format("[ProximityController] No action found for '%s'.", actionName))
        return
    end

    -- Executes the registered action
    action(self, player)
end

--[[
    Called before Knit services are started.
    Used for early setup if necessary.
]]
function ProximityController:KnitInit()
    -- Intentionally left empty for compatibility
end

--[[
    Called once all Knit services are available.
    Registers existing and dynamically added ProximityPrompts.

    @return nil
]]
function ProximityController:KnitStart()
    TeleporterService = Knit.GetService("TeleporterService")

    --- Registers a ProximityPrompt instance if not already registered.
    --- @param descendant Instance The object to check and register
    local function registerPrompt(descendant)
        if not descendant:IsA("ProximityPrompt") then return end
        if descendant:GetAttribute("Registered") then return end

        descendant:SetAttribute("Registered", true)
        ProximityController.new(descendant)
        print(string.format("[ProximityController] Registered Prompt: %s", descendant.Name))
    end

    -- Automatically detects new prompts added to Workspace
    Workspace.DescendantAdded:Connect(registerPrompt)

    -- Registers all existing prompts at startup
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        registerPrompt(descendant)
    end

    print("[ProximityController] Successfully started.")
end

return ProximityController
