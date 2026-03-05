local currRoms = workspace:WaitForChild("CurrentRooms")

local function ApplyHardcoreTheme(room)
    -- tostring(room) ensures we handle the room name correctly
    for _, obj in pairs(room:GetDescendants()) do
        -- Walls and Floors logic
        if obj:IsA("BasePart") then
            if obj.Name == "Wall" or obj.Name == "Floor" then
                obj.Material = Enum.Material.Limestone
                obj.Color = Color3.fromRGB(25, 25, 25)
            end
        end
        
        -- Rugs logic
        if obj.Name == "Rug" then
            obj:Destroy()
        end

		if obj:IsA("Light") then
			obj.Brightness = obj.Brightness - 0.21
		end

		if obj.Name == "Chandelier" then
			obj:Destroy()
		end
    end
end

-- 1. Apply to rooms already in the workspace
for _, room in pairs(currRoms:GetChildren()) do
    ApplyHardcoreTheme(room)
end

-- 2. Apply to every new room that spawns during the game
currRoms.ChildAdded:Connect(function(room)
    -- Small delay to ensure the room parts have loaded
    task.wait(0.5)
    ApplyHardcoreTheme(room)
end)
