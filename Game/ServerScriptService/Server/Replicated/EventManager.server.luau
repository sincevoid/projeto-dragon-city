local ReplicatedStorage = game:GetService("ReplicatedStorage")

--@doc Events: Folder - Pasta que contém todos os eventos remotos
local Events = Instance.new("Folder", ReplicatedStorage)
Events.Name = "Events"

--@doc Teleporter: RemoteEvent - Usado para teletransportar jogadores entre lugares
local Teleporter = Instance.new("RemoteEvent", Events)
Teleporter.Name = "Teleporter"