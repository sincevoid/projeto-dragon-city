repeat
	task.wait()
until game:IsLoaded()

-- espera carregar (o game:isloaded nao ta carregando o windmill direito)
task.wait(5) --> pensar em solução que funcione pra todos os pcs

local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Windmill = CollectionService:GetTagged("animatedWindmill")[1]
if not Windmill then
	-- jogo nao carregou ou alguem tiro o windmill
end

local speed = Windmill:WaitForChild("Attributes").RotationSpeed.Value

RunService.Heartbeat:Connect(function(deltaTime)
	if not game:IsLoaded() then
		return
	end
	-- # _G.print("Windmill")
	local rotation = CFrame.Angles(0, 0, speed * deltaTime)
	Windmill.CFrame = Windmill.CFrame * rotation
end)
