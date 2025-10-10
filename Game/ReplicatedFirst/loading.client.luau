local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")

local loadingScreen = ReplicatedFirst:WaitForChild("LoadingScreen", 10)
if loadingScreen and not RunService:IsStudio() then
    loadingScreen.Parent = Players.LocalPlayer.PlayerGui
    ReplicatedFirst:RemoveDefaultLoadingScreen()
end




-- Remove the default loading screen
