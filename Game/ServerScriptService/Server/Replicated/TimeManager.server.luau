local Lighting = game:GetService("Lighting")
-- Transition Time in Lightning

-- random initial time
Lighting:SetMinutesAfterMidnight(math.random(0, 1440))

while true do
    local m = Lighting:GetMinutesAfterMidnight()
    Lighting:SetMinutesAfterMidnight((m + 0.05) % 1440)
    task.wait()
end