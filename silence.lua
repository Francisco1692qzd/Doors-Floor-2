local G = getgenv()
local ReplicatedStorage = game.ReplicatedStorage
local playerGui = game.Players.LocalPlayer.PlayerGui
local remotesFolder = ReplicatedStorage.RemotesFolder
local moduleScripts = {
	Module_Events = require(ReplicatedStorage.ModulesClient.Module_Events),
	Main_Game = require(playerGui.MainUI.Initiator.Main_Game),
	Earthquake = require(remotesFolder.RequestAsset:InvokeServer("Earthquake"))
}

-- LOADER ESTÁVEL
G.LoadGithubModel = function(url)
    if not (writefile and getcustomasset and request) then return nil end
    local response = request({Url = url, Method = "GET"})
    if response.StatusCode ~= 200 then return nil end
    local fileName = "silence_" .. tick() .. ".rbxm"
    writefile(fileName, response.Body)
    local assetId = getcustomasset(fileName)
    local success, result = pcall(function() return game:GetObjects(assetId)[1] end)
    return success and result or nil
end

task.spawn(function()
	if not moduleScripts.Module_Events then return end
    local rawURL = "https://github.com/Francisco1692qzd/Doors-Floor-2/blob/main/creepySilence.rbxm?raw=true"
    local entity = nil
    local roomValues = ReplicatedStorage.GameData.LatestRoom
    local cameraShaker = require(ReplicatedStorage.CameraShaker)
    local camera = workspace.CurrentCamera
    local killed = false
    local val = 35
	  local ambruhspeed = 25
	  local extraspeed = 75
	  local ambruhheight = Vector3.new(0,2.4,0)
    local camShake = cameraShaker.new(Enum.RenderPriority.Camera.Value, function(cf)
        camera.CFrame = camera.CFrame * cf
    end)
    camShake:Start()
    local function GetLastRoom()
        return workspace.CurrentRooms:WaitForChild(roomValues.Value + 1)
    end
	local currentRoom = workspace.CurrentRooms:FindFirstChild(roomValues.Value)
	if currentRoom then
		moduleScripts.Module_Events.flicker(currentRoom, 2)
	end

    if G.LoadGithubModel then
        entity = G.LoadGithubModel(rawURL)
        if entity then
            entity.Parent = workspace
            print("Silence added")
        end
    end

    if not entity then print("Silence not added") return end

    local pr = entity:FindFirstChildWhichIsA("BasePart")
    pr.CFrame = GetLastRoom().RoomExit.CFrame
    
    local function GetTime(dist, speed)
        return dist/speed
    end
    local function canSeeTarget(target, size)
        if killed == true then
            return
        end

        local origin = pr.Position
        local direction = (target.HumanoidRootPart.Position - origin).unit * size
        local ray = Ray.new(origin, direction)

        local hit, pos = workspace:FindPartOnRay(ray, pr)

        if hit then
            if hit:IsDescendantOf(target) then
                killed = true
                return true
            end
        else
            return false
        end
    end
    wait(1)
	local gruh = workspace.CurrentRooms
	local runnedOnce = false
	spawn(function()
		while entity ~= nil and pr ~= nil and entity.Parent ~= nil do wait(0.8)
			local v = playerGui.Parent
			if v.Character ~= nil and v.Character.HumanoidRootPart ~= nil then
				if canSeeTarget(v.Character, 45) and not v.Character:GetAttribute("Hiding") then
					print("fuck you bit")
					for i, v in ipairs(pr:GetDescendants()) do
						if v:IsA("Sound") and runnedOnce == false then
							runnedOnce = true
							v:Stop()
						end
					end
					v.Character.Humanoid:TakeDamage(100)
					remotesFolder.Parent.GameStats["Player_".. v.Character.Name].Total.DeathCause.Value = "Silence"
					firesignal(remotesFolder.DeathHint.OnClientEvent, {"You died to who you call Silence...", "His presence is known by coming through the next door...", "Hide or search for a safe spot!"}, "Blue")
				end
			end
			if v.Character ~= nil and v.Character.HumanoidRootPart ~= nil and (pr.Position - v.Character.HumanoidRootPart.Position).magnitude <= val then
				camShake:ShakeOnce(5, 8, 0.5, 1)
			end
		end
	end)
	for i = roomValues.Value, 1, -1 do
		if gruh:FindFirstChild(tostring(i)) then
			local room = gruh[i]
			if room and room:FindFirstChild("Nodes") then
				local nodes = room["Nodes"]
				for v = #nodes:GetChildren(), 1, -1 do
					if nodes:FindFirstChild(tostring(v)) then
						local node = nodes[v]
						local distance = (pr.Position - node.Position).magnitude
						local real = game.TweenService:Create(pr, TweenInfo.new(GetTime(distance, ambruhspeed), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = node.CFrame + ambruhheight})
						real:Play()
						real.Completed:Wait()
					end
				end
			end
		end
	end
	wait(2)
	ambruhspeed = ambruhspeed + extraspeed
	for i = 1, roomValues.Value + 1 do
		if gruh:FindFirstChild(tostring(i)) then
			local room = gruh[i]
			if room and room:FindFirstChild("Nodes") then
				local nodes = room["Nodes"]
				for v = 1, #nodes:GetChildren() do
					if nodes:FindFirstChild(tostring(v)) then
						local node = nodes[v]
						local distance = (pr.Position - node.Position).magnitude
						local real = game.TweenService:Create(pr, TweenInfo.new(GetTime(distance, ambruhspeed), Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {CFrame = node.CFrame + ambruhheight})
						real:Play()
						real.Completed:Wait()
					end
				end
			end
		end
	end
	entity:Destroy()
	entity = nil
	runnedOnce = nil
end)
