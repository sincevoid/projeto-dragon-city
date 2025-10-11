local ActionsController = {}
ActionsController.__index = ActionsController
ActionsController.Actions = {
    ["TeleportOwnIsland"] = function(self, player)
        return self.Knit.Services.TeleporterService.RF:Fire(player, "OwnIsland")
    end,
}

function ActionsController.new(Knit, PromptController)
    local self = setmetatable({}, ActionsController)
    self.Knit = Knit
    self.PromptController = PromptController
    self.Prompt = PromptController.Prompt

    self.Prompt.Triggered:Connect(function()
        self:OnTrigger()
    end)

    return self
end

function ActionsController.OnTrigger(self)
    local actionName = self.Prompt:GetAttribute("ActionName")
    if not actionName then
        return warn("ProximityPrompt missing 'ActionName' attribute")
    end

    local action = ActionsController.Actions[actionName]
    if not action then
        return warn("No action found for name: " .. actionName)
    end

    return action(self, game.Players.LocalPlayer)
end

return ActionsController