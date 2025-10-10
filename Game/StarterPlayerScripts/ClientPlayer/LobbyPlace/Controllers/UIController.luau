local TweenService = game:GetService("TweenService")
local Knit = require(game.ReplicatedStorage.Packages.knit)

local UIController = Knit.CreateController({
    Name = "UIController",
})

local ScreenManager = {}
ScreenManager.__index = ScreenManager

function ScreenManager.new(screenGui: ScreenGui)
    local self = setmetatable({}, ScreenManager)

    self.ScreenGui = screenGui
    self.Backframe = screenGui:FindFirstChildWhichIsA("Frame")
    if not self.Backframe then
        error("ScreenGui must have a Frame as a child")
    end

    return self
end

function ScreenManager:TransitionToShow(tweenInfo: TweenInfo?)
    -- Trocar a posição do frame para ficar invisivel e depois um tween para a posição visivel
    local targetPosition = UDim2.fromScale(0,0)
    local startPosition = UDim2.fromScale(0, -1)
    self.Backframe.Position = startPosition
    self.ScreenGui.Enabled = true

    local tween = TweenService:Create(self.Backframe, tweenInfo or TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPosition})
    tween:Play()
    return tween
end

function ScreenManager:TransitionToHide(tweenInfo: TweenInfo?)
    -- Trocar a posição do frame para ficar visivel e depois um tween para a posição invisivel
    local targetPosition = UDim2.fromScale(0, -1)
    local startPosition = UDim2.fromScale(0, 0)
    self.Backframe.Position = startPosition

    local tween = TweenService:Create(self.Backframe, tweenInfo or TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPosition})
    tween:Play()
    tween.Completed:Once(function(playbackState)
        if playbackState == Enum.PlaybackState.Completed then
            self.Backframe.Position = startPosition
            self.ScreenGui.Enabled = false
        end
    end)
    return tween
end

function UIController.KnitInit()
    --> não é seguro para acessar outros controllers
    --> inicialize o controller aqui
end

function UIController.KnitStart()
    --> safe para acessar outros controllers
end

function UIController:CreateScreenManager(screenGui: ScreenGui)
    return ScreenManager.new(screenGui)
end

return UIController
