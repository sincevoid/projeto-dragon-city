local Game = game
local ReplicatedFirst = Game:GetService("ReplicatedFirst")
ReplicatedFirst:RemoveDefaultLoadingScreen()
local TeleportService = Game:GetService("TeleportService")
local TweenService = Game:GetService("TweenService")
local Players = Game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function OnPlayerTeleport(TeleportStatus)
	if TeleportStatus.Name ~= "Started" then return end
	local FadeIn = TweenService:Create(PlayerGui.LoadingScreenGui.LoadingScreenFrame, TweenInfo.new(5), {BackgroundTransparency = 0}) 
end

local function OnLocalPlayerArrivedFromTeleport(LoadingScreenGui)
	TeleportService:SetTeleportGui(LoadingScreenGui)
	local FadeOut = TweenService:Create(LoadingScreenGui.LoadingScreenFrame, TweenInfo.new(5), {BackgroundTransparency = 1}) 
	FadeOut:Play()
end

LocalPlayer.OnTeleport:Connect(OnPlayerTeleport)
TeleportService.LocalPlayerArrivedFromTeleport:Connect(OnLocalPlayerArrivedFromTeleport)

local LoadingScreenGui = TeleportService:GetArrivingTeleportGui()
if not LoadingScreenGui then
	LoadingScreenGui = Instance.new("ScreenGui")
	LoadingScreenGui.Name = "LoadingScreenGui"
	LoadingScreenGui.IgnoreGuiInset = true
	LoadingScreenGui.ResetOnSpawn = false
	LoadingScreenGui.Parent = PlayerGui
	
	local LoadingScreenFrame = Instance.new("Frame")
	LoadingScreenFrame.Name = "LoadingScreenFrame"
	LoadingScreenFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	LoadingScreenFrame.Size = UDim2.new(1, 0, 1, 0)
	LoadingScreenFrame.Parent = LoadingScreenGui
	
	task.spawn(OnLocalPlayerArrivedFromTeleport, LoadingScreenGui)
end