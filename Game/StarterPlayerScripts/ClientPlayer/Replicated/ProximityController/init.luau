local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Knit = require(game.ReplicatedStorage.Packages.knit)
local Trove = require(game.ReplicatedStorage.Packages.trove)

local TeleporterService

local Player = Players.LocalPlayer

local ProximityController = Knit.CreateController({
    Name = "ProximityController",
})

ProximityController.Prompts = {}

local ActionsController = {}
ActionsController.__index = ActionsController
ActionsController.Actions = {
    ["TeleportOwnIsland"] = function()
        return TeleporterService:CallTeleport(Player, "OwnIsland")
    end,
}
function ActionsController.new(ProximityPrompt: ProximityPrompt)
        local self = setmetatable({}, ActionsController)
    self._trove = Trove.new()
    
    if not ProximityPrompt then
        return error("No ProximityPrompt provided")
    end

    if not ProximityPrompt:IsA("ProximityPrompt") then
        return error("Provided object is not a ProximityPrompt")
    end
    
    local prompt = ProximityPrompt
    self.OnTrigger = self._trove:Add(Instance.new("BindableEvent"))
    self.Prompt = prompt
    
    self._trove:Connect(prompt.Triggered, function(player)
        self.OnTrigger:Fire()
        ProximityController:OnTrigger(player)
    end)

    return self
end

function ProximityController.new(ProximityPrompt: ProximityPrompt)
    local self = setmetatable({}, ProximityController)
    self.Prompt = ProximityPrompt
    self.ActionsController = ActionsController.new(ProximityPrompt)

    return self
end

function ProximityController:Destroy()
    self._trove:Destroy()
    self.ActionsController:Destroy()
end

function ProximityController:OnTrigger(player)
    local actionName = self.Prompt:GetAttribute("ActionName")
    if not actionName then
        return warn("ProximityPrompt missing 'ActionName' attribute")
    end

    local action = ActionsController.Actions[actionName]
    if not action then
        return warn("No action found for ActionName: ", actionName)
    end

    action(self, player)
end

function ProximityController.KnitInit() return end

function ProximityController.KnitStart()
    TeleporterService = Knit.GetService("TeleporterService")

    local function identify(descendant)
        if not descendant:IsA("ProximityPrompt") then return end
        if table.find(ProximityController.Prompts, descendant) then return end
        table.insert(ProximityController.Prompts, descendant)
        local Prompt = ProximityController.new(descendant)
        print("Proximity Prompt Adicionado: ", Prompt.Prompt.Name)
    end

    Workspace.DescendantAdded:Connect(function(descendant)
        identify(descendant)
    end)

    for _, descendant in Workspace:GetDescendants() do
        identify(descendant)
    end


    print("ProximityController is running")
end

return ProximityController
