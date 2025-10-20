-- BeltSystem.lua
-- Cada jogador tem sua própria instância de esteira
local RunService = game:GetService("RunService")

local BeltSystem = {}
BeltSystem.__index = BeltSystem

export type Belt = {
	Player: Player,
	Waypoints: { Vector3 },
	Speed: number,
	SpawnRate: number,
	EggModule: any,
	Eggs: {},
	Active: boolean,
	Connection: RBXScriptConnection?,
}

function BeltSystem.new(player: Player, waypoints: { BasePart }, speed: number, spawnRate: number, eggModule: any)
	local self: Belt = setmetatable({}, BeltSystem)
	self.Player = player
	self.Waypoints = {}
	self.Speed = speed or 6
	self.SpawnRate = spawnRate or 3
	self.EggModule = eggModule
	self.Eggs = {}
	self.Active = false

	for _, part in ipairs(waypoints) do
		table.insert(self.Waypoints, part.Position)
	end

	return self
end

function BeltSystem:Start()
	if self.Active then
		return
	end
	self.Active = true

	-- Atualiza posição dos ovos
	self.Connection = RunService.Heartbeat:Connect(function(dt)
		for i = #self.Eggs, 1, -1 do
			local egg = self.Eggs[i]
			if not egg or not egg.PrimaryPart then
				table.remove(self.Eggs, i)
				continue
			end

			egg:SetAttribute("Progress", egg:GetAttribute("Progress") + self.Speed * dt)
			local pos = self:_GetPositionOnPath(egg:GetAttribute("Progress"))
			if not pos then
				egg:Destroy()
				table.remove(self.Eggs, i)
			else
				egg:PivotTo(CFrame.new(pos))
			end
		end
	end)

	-- Cria ovos automaticamente
	task.spawn(function()
		while self.Active do
			self:SpawnEgg()
			task.wait(self.SpawnRate)
		end
	end)
end

function BeltSystem:Stop()
	self.Active = false
	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end
end

function BeltSystem:SpawnEgg()
	local eggModelName = self.EggModule:GetRandomEgg()
	local eggTemplate = game.ReplicatedStorage.Assets.Eggs:FindFirstChild(eggModelName)
	if not eggTemplate then
		return
	end

	local newEgg = eggTemplate:Clone()
	newEgg.Parent = workspace
	newEgg:SetAttribute("Progress", 0)
	table.insert(self.Eggs, newEgg)
end

function BeltSystem:_GetPositionOnPath(progress)
	local total = 0
	for i = 1, #self.Waypoints - 1 do
		local a = self.Waypoints[i]
		local b = self.Waypoints[i + 1]
		local dist = (b - a).Magnitude

		if progress < total + dist then
			local t = (progress - total) / dist
			return a:Lerp(b, t)
		end
		total += dist
	end
	return nil
end

return BeltSystem
