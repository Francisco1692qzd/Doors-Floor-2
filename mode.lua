-- [[ FLOOR 2 HARDCORE MODE - FULL SYNC VERSION ]] --
-- Credits: Original by Noonie and Ping. 
-- Optimized for Xeno/Velocity/Gemini Sync

local G = getgenv()
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TS = game:GetService("GetService") and game:GetService("TweenService") or game:GetService("TweenService")
local LatestRoom = ReplicatedStorage.GameData.LatestRoom

-- [[ CONFIGURATION ]]
local entitiesURLs = {
    Silence = "https://raw.githubusercontent.com/Francisco1692qzd/Doors-Floor-2/refs/heads/main/silence.lua",
    Depth   = "https://raw.githubusercontent.com/Francisco1692qzd/Doors-Floor-2/refs/heads/main/depth.lua",
    Trauma  = "https://raw.githubusercontent.com/Francisco1692qzd/Doors-Floor-2/refs/heads/main/trauma.lua",
    Rage    = "https://raw.githubusercontent.com/Francisco1692qzd/Doors-Floor-2/refs/heads/main/rage.lua"
}

local messages = {
    "Goddamned entities gave work too.",
    "Nope, not recreating another again",
    "Thanks to Gemini",
    "I'd thought Gemini never existed, until i met him.",
    "Wow... I love Gemini."
}

-- [[ MULTIPLAYER SYNC DATA ]]
local syncFolder = workspace:FindFirstChild("Floor2Sync") or Instance.new("Folder", workspace)
syncFolder.Name = "Floor2Sync"
local startTimeValue = syncFolder:FindFirstChild("Floor2StartTime") or Instance.new("NumberValue", syncFolder)
startTimeValue.Name = "Floor2StartTime"

local function SyncWait(seconds)
    if startTimeValue.Value == 0 then 
        repeat task.wait(0.5) until startTimeValue.Value > 0 
    end
    local targetTime = startTimeValue.Value + seconds
    while workspace:GetServerTimeNow() < targetTime do 
        task.wait(0.1) 
    end
end

-- [[ SYSTEM FUNCTIONS ]]
local function ShowCaption(text, duration)
    local pGui = Player:WaitForChild("PlayerGui")
    if pGui:FindFirstChild("HardcoreCaption") then pGui.HardcoreCaption:Destroy() end
    local screenGui = Instance.new("ScreenGui", pGui)
    screenGui.Name = "HardcoreCaption"
    screenGui.IgnoreGuiInset = true
    
    local captionLabel = Instance.new("TextLabel", screenGui)
    captionLabel.Size = UDim2.new(0.6, 0, 0.05, 10)
    captionLabel.Position = UDim2.new(0.5, 0, 0.92, -60)
    captionLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    captionLabel.BackgroundTransparency = 1
    captionLabel.Text = text
    captionLabel.TextColor3 = Color3.fromRGB(255, 222, 189)
    captionLabel.TextSize = 30
    captionLabel.Font = Enum.Font.Oswald
    captionLabel.TextStrokeTransparency = 0
    
    local alertSound = Instance.new("Sound", game.SoundService)
    alertSound.SoundId = "rbxassetid://3848738542"
    alertSound:Play()
    game.Debris:AddItem(alertSound, 2)
    
    task.delay(duration or 4, function()
        if captionLabel then
            TS:Create(captionLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            task.wait(0.5) screenGui:Destroy()
        end
    end)
end

local function SafeSpawn(entity)
    -- Don't spawn entities during boss fights or cutscenes
    if workspace:FindFirstChild("SeekMoving") or workspace:FindFirstChild("SeekMovingNewClone") then return end
    if LatestRoom.Value == 50 or LatestRoom.Value == 100 then return end
    
    if entitiesURLs[entity] then
        task.spawn(function()
            pcall(function() 
                loadstring(game:HttpGet(entitiesURLs[entity]))() 
            end)
        end)
    end
end

pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Francisco1692qzd/Doors-Floor-2/refs/heads/main/floor2-script.lua"))() end)

-- [[ INITIALIZATION ]]
local alreadyRan = workspace:FindFirstChild("ExecutedFloor2")
if not alreadyRan and LatestRoom.Value == 0 then
    local check = Instance.new("BoolValue", workspace)
    check.Name = "ExecutedFloor2"
    ShowCaption("Floor 2 Script Loaded.", 5)
elseif alreadyRan and LatestRoom.Value == 0 then
    ShowCaption("Already Running Floor 2!", 3)
    return
elseif LatestRoom.Value ~= 0 then
    ShowCaption("ERROR: Please execute at Door 0!", 5)
    if Character then Character:FindFirstChildOfClass("Humanoid"):TakeDamage(1000) end
    return
end

-- Load Nodes
pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Francisco1692qzd/OverridenEntitiesMode/refs/heads/main/nodes.lua"))() end)

-- [[ MAIN GAME LOOP ]]
local openeddoor1 = false
LatestRoom.Changed:Connect(function()
    if LatestRoom.Value == 1 and not openeddoor1 then
        openeddoor1 = true
        
        -- Set Server Start Time
        if startTimeValue.Value == 0 then
            startTimeValue.Value = workspace:GetServerTimeNow()
        end

        ShowCaption("Floor 2 Initiated.", 5)
        task.wait(4)
        ShowCaption("Wow, Never thought the mode was gonna be so easy to create", 7)
        task.wait(7)
        ShowCaption(messages[math.random(1, #messages)], 6)

		-- [[ SYNCED ENTITY SPAWNER SCHEDULER ]]
        
        -- SILENCE (Rarely appearing at 280s, 365s)
        task.spawn(function()
            local c = 0
            while true do
                SyncWait(c + 280) SafeSpawn("Silence")
                SyncWait(c + 365) SafeSpawn("Silence")
                c = c + 450 -- Increased cycle to keep it rarer
                task.wait(1)
            end
        end)

        -- DEPTH (Significantly rarer at 240s, 321s)
        task.spawn(function()
            local c = 0
            while true do
                SyncWait(c + 240) SafeSpawn("Depth")
                SyncWait(c + 321) SafeSpawn("Depth")
                c = c + 421 -- Longer cycle before repeating
                task.wait(1)
            end
        end)

        -- RAGE (420, 610)
        task.spawn(function()
            local c = 0
            while true do
                SyncWait(c + 420) SafeSpawn("Rage")
                SyncWait(c + 610) SafeSpawn("Rage")
                c = c + 785
                task.wait(1)
            end
        end)

        -- TRAUMA (276, 325)
        task.spawn(function()
            local c = 0
            while true do
                SyncWait(c + 276) SafeSpawn("Trauma")
                SyncWait(c + 325) SafeSpawn("Trauma")
                c = c + 432
                task.wait(1)
            end
        end)
    end
end)
